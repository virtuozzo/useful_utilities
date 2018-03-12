module UsefulUtilities
  # Numeric utilities
  module Numeric
    extend self

    ZERO = 0
    THOUSAND = 1_000
    MILLION = 1_000_000
    BILLION = 1_000_000_000

    # @param value [Numeric]
    # @return [Numeric]
    # @example
    #   UsefulUtilities::Numeric.positive_or_zero(1)  #=> 1
    #   UsefulUtilities::Numeric.positive_or_zero(-1) #=> 0
    def positive_or_zero(value)
      (value > ZERO) ? value : ZERO
    end

    # @param value [Numeric]
    # @return [Numeric] value if value can not be coerced to integer
    def float_or_integer(value)
      value == value.to_i ? value.to_i : value
    end

    # @param value [Numeric]
    # @option scale [Integer] :scale (nil)
    # @return [BigDecimal] value as BigDecimale rounded to scale
    def to_decimal(value, scale: nil)
      result = value.to_f.to_d

      scale ? result.round(scale) : result
    end

    # @param value [Numeric]
    # @param unit [Symbol]
    # @return [Numeric] value converted to kilo
    def to_kilo(value, unit)
      if    unit == :M then value * THOUSAND
      elsif unit == :G then value * MILLION
      else  unsupported_unit!(unit)
      end
    end

    # @param value [Numeric]
    # @param unit [Symbol]
    # @return [Numeric] value converted to giga
    def to_giga(value, unit)
      if    unit == :k then value.fdiv(MILLION)
      elsif unit == :M then value.fdiv(THOUSAND)
      else  unsupported_unit!(unit)
      end
    end


    # @param value [Numeric]
    # @param unit [Symbol]
    # @return [Numeric] value converted to number
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
