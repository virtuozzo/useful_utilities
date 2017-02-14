require_relative 'standard/decimal'

module Utils
  module Size
    module CdnByte
      # @note: used SI standard http://en.wikipedia.org/wiki/Binary_prefix
      #   Decimal
      #   1 K = 1000
      include Utils::Size::Standard::Decimal

      THOUSAND = 1_000

      def to_cdn_gigabytes(size, unit)
        #TODO check if it still in use
        if unit == :Mbit
          return size.fdiv(THOUSAND)/8
        end

        to_giga(size, unit)
      end

      def to_cdn_bytes(size, unit)
        to_decimal_bi(size, unit)
      end

      private

      def unsupported_unit!(unit)
        raise ArgumentError.new("Unsupported unit - #{ unit }")
      end
    end
  end
end
