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
    module Bit
      include UsefulUtilities::Size::Standard::Decimal

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in terabits
      def to_terabits(size, unit)
        to_tera(size, bit_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in gigabits
      def to_gigabits(size, unit)
        to_giga(size, bit_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in megabits
      def to_megabits(size, unit)
        to_mega(size, bit_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in kilobits
      def to_kilobits(size, unit)
        to_kilo(size, bit_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in bits
      def to_bits(size, unit)
        to_decimal_bi(size, bit_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @param rounder [Integer]
      # @return [Numeric] humanized size in provided unit
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

      # @param value [Integer]
      # @return [Symbol] suitable unit
      # @raise [ArgumentError] if value is less than zero
      def suitable_unit_for_bits(value)
        value = value.to_i

        return not_positive!(value) if value.negative?

        if value.to_s.length    <= 3  then :bit
        elsif value.to_s.length <= 6  then :kbit
        elsif value.to_s.length <= 9  then :Mbit
        elsif value.to_s.length <= 12 then :Gbit
        else :Tbit
        end
      end

      # @param value_in_bits [Integer] value in bits
      # @return [String] human readable value
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

      def not_positive!(value)
        raise ArgumentError.new("#{value} is not positive")
      end
    end
  end
end
