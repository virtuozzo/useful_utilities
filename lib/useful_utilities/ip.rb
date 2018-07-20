require 'ipaddr'

module UsefulUtilities
  # Provides a bunch of convinient methods to deal with ip addresses
  # The module rely on stdlib ipaddr
  module IP
    IPV4 = 4
    IPV6 = 6
    IPVERSIONS = [IPV4, IPV6].freeze
    MAX_NET_MASK_IPV4 = 32
    MAX_NET_MASK_IPV6 = 128
    MIN_NET_MASK      = 0
    ZERO_IP_INTEGER   = 0

    # integer representing ip '10.0.0.0', start of '10.0.0.0/8'
    PRIVATE_RANGE_10_START = 167772160
    # integer representing ip '10.255.255.255', end of '10.0.0.0/8'
    PRIVATE_RANGE_10_END   = 184549375

    # integer representing ip '172.16.0.0', start of '172.16.0.0/12'
    PRIVATE_RANGE_172_START = 2886729728
    # integer representing ip '172.31.255.255', end of '172.16.0.0/12'
    PRIVATE_RANGE_172_END   = 2887778303

    # integer representing ip '192.168.0.0', start of '192.168.0.0/16'
    PRIVATE_RANGE_192_START = 3232235520
    # integer representing ip '192.168.255.255', end of '192.168.0.0/16'
    PRIVATE_RANGE_192_END   = 3232301055

    # integer representing ip 'fc00::', start of 'fc00::/7'
    PRIVATE_RANGE_FC_START = 334965454937798799971759379190646833152
    # integer representing ip 'fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff',
    # end of 'fc00::/7'
    PRIVATE_RANGE_FC_END   = 337623910929368631717566993311207522303

    private_constant :IPV4,
                     :IPV6,
                     :IPVERSIONS,
                     :MAX_NET_MASK_IPV4,
                     :MAX_NET_MASK_IPV6,
                     :MIN_NET_MASK,
                     :ZERO_IP_INTEGER,
                     :PRIVATE_RANGE_10_START,
                     :PRIVATE_RANGE_10_END,
                     :PRIVATE_RANGE_172_START,
                     :PRIVATE_RANGE_172_END,
                     :PRIVATE_RANGE_192_START,
                     :PRIVATE_RANGE_192_END,
                     :PRIVATE_RANGE_FC_START,
                     :PRIVATE_RANGE_FC_END

    extend self

    # @param ip_string [String]
    # @return [Boolean] true if supplied string is parsable ip address string
    # and false otherwise
    # @example
    #   UsefulUtilities::IP.valid_ip('10.10.0.1') #=> true
    #   UsefulUtilities::IP.valid_ip('non-parsable-ip') #=> false
    def valid_ip?(ip_string)
      IPAddr.new(ip_string)
      true
    rescue IPAddr::InvalidAddressError, IPAddr::AddressFamilyError
      false
    end

    # @param ip_string [String]
    # @return [Boolean] true if ip_string represent private ip address.
    # If ip_sting is non-parsable ip address ArgumentError raises.
    # It is a wrapper on the private? method of IPAddr class instance.
    # IPv4 addresses in 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16 as defined
    # in RFC 1918 and IPv6 Unique Local Addresses in fc00::/7 as defined in
    # RFC 4193 are considered private.
    # @example
    #   UsefulUtilities::IP.private_ip?('10.10.10.10') #=> true
    #   UsefulUtilities::IP.private_ip?('8.10.10.10') #=> false
    def private_ip?(ip_string)
      ip = IPAddr.new(ip_string)

      # starting from ruby 2.5.0 an IPAddr instance has built-in private? method
      # use the built-in method if exists
      return ip.private? if ip.respond_to?(:private?)

      check_private_ip(ip)
    rescue IPAddr::InvalidAddressError, IPAddr::AddressFamilyError
      raise ArgumentError, 'Invalid ip address string supplied!'
    end

    # @param address [Integer]
    # @param version. If version is not equal 4 or 6 ArgumentError raises.
    # If supplied address can not be converted into ip address string
    # then ArgumentError raises.
    # @return string as human readable ip address.
    # @example
    #   UsefulUtilities::IP.integer_to_ip_string(1,version: 4) #=> '0.0.0.1'
    #   UsefulUtilities::IP.integer_to_ip_string(1,version: 6) #=> '::1'
    def integer_to_ip_string(address, version:)
      unless address.is_a? Integer
        raise ArgumentError, 'Supplied address is not integer!'
      end

      IPAddr.new(address, ip_address_family(version)).to_s
    rescue IPAddr::InvalidAddressError, IPAddr::AddressFamilyError
      raise ArgumentError, 'Invalid address!'
    end

    # @param ip_string [String]
    # @return integer representation of supplied ip string.
    # ArgumentError raises if ip string can not be parsed as ip address.
    # @example
    #   UsefulUtilities::IP.ip_string_to_integer('0.0.0.2') #=> 2
    #   UsefulUtilities::IP.ip_string_to_integer('::2') #=> 2
    def ip_string_to_integer(ip_string)
      IPAddr.new(ip_string).to_i
    rescue IPAddr::InvalidAddressError, IPAddr::AddressFamilyError
      raise ArgumentError, 'Invalid ip address string supplied!'
    end

    # @param ip_string [String]
    # @return array of 2 elements,
    # the first: integer representation of supplied ip string,
    # the second: version of ip protocol 4 or 6.
    # ArgumentError raises if ip string can not be parsed as ip address.
    # @example
    #   UsefulUtilities::IP.ip_string_to_integer_with_version('0.0.0.1') #=> [1, 4]
    #   UsefulUtilities::IP.ip_string_to_integer_with_version('::1') #=> [1, 6]
    def ip_string_to_integer_with_version(ip_string)
      ip = IPAddr.new(ip_string)
      version = IPV4 if ip.ipv4?
      version = IPV6 if ip.ipv6?

      [ip.to_i, version]
    rescue IPAddr::InvalidAddressError, IPAddr::AddressFamilyError
      raise ArgumentError, 'Invalid ip address string supplied!'
    end

    # @param ip_string [String]
    # @param network_mask [Integer]
    # @return [String] value representing network address derived from supplied
    # ip address and it's network mask
    # @example
    #   UsefulUtilities::IP.network_address('10.10.15.33', 24) #=> "10.10.15.0"
    def network_address(ip_string, network_mask)
      ip = IPAddr.new(ip_string)

      version = if ip.ipv4?
                  IPV4
                elsif ip.ipv6?
                  IPV6
                else
                  raise ArgumentError, 'Unsupported ip address version!'
                end

      unless acceptable_network_mask?(network_mask, version: version)
        raise ArgumentError,
              "Invalid network mask: '#{network_mask}' for address: '#{ip_string}'"
      end

      ip_network_address =
        IPAddr.new(ZERO_IP_INTEGER, ip_address_family(version))
              .~
              .<<(max_network_mask(version) - network_mask)
              .&(ip)

      ip_network_address.to_s
    rescue IPAddr::InvalidAddressError, IPAddr::AddressFamilyError
      raise ArgumentError, 'Invalid ip address string supplied!'
    end

    # @param network_mask [Integer]
    # @param version [Integer]
    # @return [Boolean]
    # ArgumentError raises if version is not equal 4 or 6.
    # @example
    #   UsefulUtilities::IP.acceptable_network_mask?('not int', version: 4) #=> false
    #   UsefulUtilities::IP.acceptable_network_mask?(24, version: 4) #=> true
    def acceptable_network_mask?(network_mask, version:)
      return false unless network_mask.is_a? Integer

      network_mask >= MIN_NET_MASK && network_mask <= max_network_mask(version)
    end

    private

    def ip_address_family(ip_version)
      return Socket::AF_INET if ip_version == IPV4
      return Socket::AF_INET6 if ip_version == IPV6

      raise ArgumentError,
            'Unsupported ip address version! '\
            "Supported argument values: #{IPV4} or #{IPV6}."
    end

    def max_network_mask(ip_version)
      return MAX_NET_MASK_IPV4 if ip_version == IPV4
      return MAX_NET_MASK_IPV6 if ip_version == IPV6

      raise ArgumentError,
            'Unsupported version supplied! '\
            "Supported version values: #{IPV4} or #{IPV6}."
    end

    def check_private_ip(ip)
      return true if ip.ipv4? && in_private_ipv4?(ip.to_i)
      return true if ip.ipv6? && in_private_ipv6?(ip.to_i)

      false
    end

    def in_private_ipv4?(integer_ip)
      [
        (PRIVATE_RANGE_10_START..PRIVATE_RANGE_10_END),
        (PRIVATE_RANGE_172_START..PRIVATE_RANGE_172_END),
        (PRIVATE_RANGE_192_START..PRIVATE_RANGE_192_END)
      ].any? { |range| range.include?(integer_ip) }
    end

    def in_private_ipv6?(integer_ip)
      (PRIVATE_RANGE_FC_START..PRIVATE_RANGE_FC_END).include?(integer_ip)
    end
  end
end
