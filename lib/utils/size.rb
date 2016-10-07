require 'active_support/core_ext/numeric/bytes'

module Utils
  module Size
    extend self

    KILOBYTE = 1.kilobyte
    MEGABYTE = 1.megabyte
    GIGABYTE = 1.gigabyte
    TERABYTE = 1.terabyte
    HUNDRED  = 100
    THOUSAND = 1_000
    MILLION  = 1_000_000
    BILLION  = 1_000_000_000

    # @note: used JEDEC standarts http://en.wikipedia.org/wiki/Binary_prefix
    def to_terabytes(size, unit)
      if    unit == :B  then size.fdiv(TERABYTE)
      elsif unit == :KB then size.fdiv(GIGABYTE)
      elsif unit == :MB then size.fdiv(MEGABYTE)
      elsif unit == :GB then size.fdiv(KILOBYTE)
      elsif unit == :TB then size
      else  unsupported_unit!(unit)
      end
    end

    def to_gigabytes(size, unit)
      if    unit == :B  then size.fdiv(GIGABYTE)
      elsif unit == :KB then size.fdiv(MEGABYTE)
      elsif unit == :MB then size.fdiv(KILOBYTE)
      elsif unit == :GB then size
      elsif unit == :TB then size * KILOBYTE
      else  unsupported_unit!(unit)
      end
    end

    def to_megabytes(size, unit)
      if    unit == :B then size.fdiv(MEGABYTE)
      elsif unit == :KB then size.fdiv(KILOBYTE)
      elsif unit == :GB then size * KILOBYTE
      elsif unit == :MB then size
      elsif unit == :TB then size * MEGABYTE
      else  unsupported_unit!(unit)
      end
    end

    def to_kilobytes(size, unit)
      if    unit == :B  then size.fdiv(KILOBYTE)
      elsif unit == :KB then size
      elsif unit == :MB then size * KILOBYTE
      elsif unit == :GB then size * MEGABYTE
      elsif unit == :TB then size * GIGABYTE
      elsif unit == :sector then (size * 0.5).round # http://en.wikipedia.org/wiki/Disk_sector
      else  unsupported_unit!(unit)
      end
    end

    def to_bytes(size, unit)
      if    unit == :B  then size
      elsif unit == :KB then size * KILOBYTE
      elsif unit == :MB then size * MEGABYTE
      elsif unit == :GB then size * GIGABYTE
      elsif unit == :TB then size * TERABYTE
      else unsupported_unit!(unit)
      end
    end

    # Convert bytes to manually defined format
    #   by using parameter 'unit'
    #   ATTENTION: by default round is eq to 3 digits
    def bytes_to_human_size(size, unit, rounder = 3)
      if    unit == :B  then size.round(rounder)
      elsif unit == :KB then to_kilobytes(size, :B).round(rounder)
      elsif unit == :MB then to_megabytes(size, :B).round(rounder)
      elsif unit == :GB then to_gigabytes(size, :B).round(rounder)
      elsif unit == :TB then to_terabytes(size, :B).round(rounder)
      else  unsupported_unit!(unit)
      end
    end

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
