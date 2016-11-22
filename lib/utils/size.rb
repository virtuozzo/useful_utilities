require 'active_support/core_ext/numeric/bytes'
require 'utils/size/bit'
require 'utils/size/byte'

module Utils
  module Size
    extend self
    extend Utils::Size::Byte
    extend Utils::Size::Bit

    HUNDRED  = 100
    THOUSAND = 1_000
    MILLION  = 1_000_000
    BILLION  = 1_000_000_000

    # @note: used `metric` standarts http://en.wikipedia.org/wiki/Binary_prefix
    def to_cdn_bytes(size, unit)
      if    unit == :GB then size * BILLION
      elsif unit == :MB then size * MILLION
      elsif unit == :KB then size * THOUSAND
      else  unsupported_unit!(unit)
      end
    end

    def to_cdn_gigabytes(size, unit)
      if    unit == :B  then size.fdiv(BILLION)
      elsif unit == :KB then size.fdiv(MILLION)
      elsif unit == :MB then size.fdiv(THOUSAND)
      elsif unit == :Mbit then size.fdiv(THOUSAND) / 8
      else  unsupported_unit!(unit)
      end
    end

    def to_megahertz(size, unit)
      if    unit == :Hz then size.fdiv(MILLION)
      elsif unit == :KHz then size.fdiv(THOUSAND)
      elsif unit == :GHz then size * THOUSAND
      else  unsupported_unit!(unit)
      end
    end

    def to_gigahertz(size, unit)
      if    unit == :Hz then size.fdiv(BILLION)
      elsif unit == :KHz then size.fdiv(MILLION)
      elsif unit == :MHz then size.fdiv(THOUSAND)
      else  unsupported_unit!(unit)
      end
    end

    def fraction_to_percentage(fraction)
      fraction * HUNDRED
    end

    def percentage_to_fraction(percentage)
      percentage.fdiv(HUNDRED)
    end

    private

    def unsupported_unit!(unit)
      raise ArgumentError.new("Unsupported unit - #{ unit }")
    end
  end
end
