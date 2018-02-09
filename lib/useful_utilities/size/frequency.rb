require_relative 'standard/decimal'

module UsefulUtilities
  module Size
    module Frequency
      # @note: used SI standard http://en.wikipedia.org/wiki/Binary_prefix
      #   Decimal
      #   1 K = 1000
      include UsefulUtilities::Size::Standard::Decimal

      def to_megahertz(size, unit)
        to_mega(size, frequency_prefix(unit))
      end

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
