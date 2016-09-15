module Utils
  module Numeric
    extend self

    ZERO = 0
    THOUSAND = 1_000
    MILLION = 1_000_000
    BILLION = 1_000_000_000

    def positive_or_zero(value)
      (value > ZERO) ? value : ZERO
    end

    def float_or_integer(value)
      value == value.to_i ? value.to_i : value
    end

    def to_decimal(value, scale: nil)
      result = value.to_f.to_d

      scale ? result.round(scale) : result
    end

    # @note: used SI metric prefixes http://en.wikipedia.org/wiki/SI_prefix
    def to_kilo(value, unit)
      if    unit == :M then value * THOUSAND
      elsif unit == :G then value * MILLION
      else  unsupported_unit!(unit)
      end
    end

    def to_giga(value, unit)
      if    unit == :k then value.fdiv(MILLION)
      elsif unit == :M then value.fdiv(THOUSAND)
      else  unsupported_unit!(unit)
      end
    end

    def to_number(value, unit)
      if    unit == :M then value * MILLION
      elsif unit == :G then value * BILLION
      else  unsupported_unit!(unit)
      end
    end

    private

    def unsupported_unit!(unit)
      raise ArgumentError.new("Unsupported unit - #{ unit }")
    end
  end
end
