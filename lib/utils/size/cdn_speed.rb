require_relative 'standard/decimal'

module Utils
  module Size
    module CdnSpeed
      # @note: used SI standard http://en.wikipedia.org/wiki/Binary_prefix
      #   Decimal
      #   1 K = 1000
      include Utils::Size::Standard::Decimal

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
