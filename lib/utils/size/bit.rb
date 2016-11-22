module Utils
  module Size
    module Bit
      KILOBIT = 1_000.freeze
      MEGABIT = 1_000_000.freeze
      GIGABIT = 1_000_000_000.freeze
      TERABIT = 1_000_000_000_000.freeze

      # @note: used JEDEC standarts http://en.wikipedia.org/wiki/Binary_prefix
      #   Decimal
      #   1 kbit = 1000 bit
      def to_terabits(size, unit)
        if    unit == :bit  then size.fdiv(TERABIT)
        elsif unit == :kbit then size.fdiv(GIGABIT)
        elsif unit == :Mbit then size.fdiv(MEGABIT)
        elsif unit == :Gbit then size.fdiv(KILOBIT)
        elsif unit == :Tbit then size
        else  unsupported_unit!(unit)
        end
      end

      def to_gigabits(size, unit)
        if    unit == :bit  then size.fdiv(GIGABIT)
        elsif unit == :kbit then size.fdiv(MEGABIT)
        elsif unit == :Mbit then size.fdiv(KILOBIT)
        elsif unit == :Gbit then size
        elsif unit == :Tbit then size * KILOBIT
        else  unsupported_unit!(unit)
        end
      end

      def to_megabits(size, unit)
        if    unit == :bit then size.fdiv(MEGABIT)
        elsif unit == :kbit then size.fdiv(KILOBIT)
        elsif unit == :Gbit then size * KILOBIT
        elsif unit == :Mbit then size
        elsif unit == :Tbit then size * MEGABIT
        else  unsupported_unit!(unit)
        end
      end

      def to_kilobits(size, unit)
        if    unit == :bit  then size.fdiv(KILOBIT)
        elsif unit == :kbit then size
        elsif unit == :Mbit then size * KILOBIT
        elsif unit == :Gbit then size * MEGABIT
        elsif unit == :Tbit then size * GIGABIT
        else  unsupported_unit!(unit)
        end
      end

      def to_bits(size, unit)
        if    unit == :bit  then size
        elsif unit == :kbit then size * KILOBIT
        elsif unit == :Mbit then size * MEGABIT
        elsif unit == :Gbit then size * GIGABIT
        elsif unit == :Tbit then size * TERABIT
        else unsupported_unit!(unit)
        end
      end

      # Convert bits to manually defined format
      #   by using parameter 'unit'
      #   ATTENTION: by default round is eq to 3 digits
      def bits_to_human_size(size, unit, rounder = 3)
        if    unit == :bit  then size.round(rounder)
        elsif unit == :kbit then to_kilobits(size, :bit).round(rounder)
        elsif unit == :Mbit then to_megabits(size, :bit).round(rounder)
        elsif unit == :Gbit then to_gigabits(size, :bit).round(rounder)
        elsif unit == :Tbit then to_terabits(size, :bit).round(rounder)
        else  unsupported_unit!(unit)
        end
      end

      # Ignore any fractional part of the number
      #   Bit can be only integer !!!
      def suitable_unit_for_bits(value)
        return not_integer!(value)          unless value.is_a?(Integer)
        return not_positive_integer!(value) unless value > -1

        if value.to_s.length    <= 3 then :bit
        elsif value.to_s.length < 6  then :kbit
        elsif value.to_s.length < 9  then :Mbit
        elsif value.to_s.length < 12 then :Gbit
        else :Tbit
        end
      end

      def bits_per_sec_to_human_readable(value_in_bits)
        unit  = suitable_unit_for_bits(value_in_bits)
        value = bits_to_human_size(value_in_bits, unit.to_sym)

        "#{value} #{unit}/s"
      end

      private

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
