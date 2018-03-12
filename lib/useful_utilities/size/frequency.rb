require_relative 'standard/decimal'

module UsefulUtilities
  module Size
    # Frequency utilities
    # Possible units:
    #   :Hz  - hertz
    #   :KHz - kilohertz
    #   :MHz - megahertz
    #   :GHz - gigahertz
    #   :THz - terahertz
    # Used SI standard http://en.wikipedia.org/wiki/Binary_prefix
    #   Decimal
    #   1 K = 1000
    module Frequency
      include UsefulUtilities::Size::Standard::Decimal

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in megahertz
      def to_megahertz(size, unit)
        to_mega(size, frequency_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in gigahertz
      def to_gigahertz(size, unit)
        to_giga(size, frequency_prefix(unit))
      end

      private

      def frequency_prefix(unit)
        case unit
        when :Hz  then :B
        when :KHz then :KB
        when :MHz then :MB
        when :GHz then :GB
        when :THz then :TB
        else unsupported_unit!(unit)
        end
      end

      def unsupported_unit!(unit)
        raise ArgumentError.new("Unsupported unit - #{ unit }")
      end
    end
  end
end
