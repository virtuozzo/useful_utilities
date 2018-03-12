require_relative 'standard/decimal'

module UsefulUtilities
  module Size
    # Possible units:
    #   :bit  - bits
    #   :kbit - kilobits
    #   :Mbit - megabits
    #   :Gbit - gigabits
    #   :Tbit - terabits
    # Used SI standard http://en.wikipedia.org/wiki/Binary_prefix
    #   Decimal
    #   1 K = 1000
    module CdnSpeed
      include UsefulUtilities::Size::Standard::Decimal

      # @param speed [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in CDN gigabits per second
      def to_cdn_gbps(speed, unit)
        to_giga(speed, bit_prefix(unit))/8
      end

      private

      def bit_prefix(unit)
        case unit
        when :bit  then :B
        when :kbit then :KB
        when :Mbit then :MB
        when :Gbit then :GB
        when :Tbit then :TB
        else unsupported_unit!(unit)
        end
      end

      def unsupported_unit!(unit)
        raise ArgumentError.new("Unsupported unit - #{ unit }")
      end
    end
  end
end
