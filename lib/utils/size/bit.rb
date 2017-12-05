require_relative 'standard/decimal'

module Utils
  module Size
    module Bit
      # @note: used SI standard http://en.wikipedia.org/wiki/Binary_prefix
      #   Decimal
      #   1 K = 1000
      include Utils::Size::Standard::Decimal

      def to_terabits(size, unit)
        to_tera(size, bit_prefix(unit))
      end

      def to_gigabits(size, unit)
        to_giga(size, bit_prefix(unit))
      end

      def to_megabits(size, unit)
        to_mega(size, bit_prefix(unit))
      end

      def to_kilobits(size, unit)
        to_kilo(size, bit_prefix(unit))
      end

      def to_bits(size, unit)
        to_decimal_bi(size, bit_prefix(unit))
      end

      # Convert bits to manually defined format
      #   by using parameter 'unit'
      #   ATTENTION: by default round is eq to 3 digits
      def bits_to_human_size(size, unit, rounder = 3)
        case unit
        when :bit  then size.round(rounder)
        when :kbit then to_kilobits(size, :bit).round(rounder)
        when :Mbit then to_megabits(size, :bit).round(rounder)
        when :Gbit then to_gigabits(size, :bit).round(rounder)
        when :Tbit then to_terabits(size, :bit).round(rounder)
        else  unsupported_unit!(unit)
        end
      end

      # Ignore any fractional part of the number
      #   Bit can be only integer !!!
      def suitable_unit_for_bits(value)
        return not_integer!(value)          unless value.is_a?(Integer)
        return not_positive_integer!(value) unless value > -1

        if value.to_s.length    <= 3  then :bit
        elsif value.to_s.length <= 6  then :kbit
        elsif value.to_s.length <= 9  then :Mbit
        elsif value.to_s.length <= 12 then :Gbit
        else :Tbit
        end
      end

      def bits_per_sec_to_human_readable(value_in_bits)
        unit  = suitable_unit_for_bits(value_in_bits)
        value = bits_to_human_size(value_in_bits, unit.to_sym)

        "#{value} #{unit}/s"
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

      def not_integer!(value)
        raise ArgumentError.new("#{value } is not integer")
      end
      def not_positive_integer!(value)
        raise ArgumentError.new("#{value } is not positive integer")
      end
    end
  end
end
