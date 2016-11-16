module Utils
  module Size
    module Byte
      KILOBYTE = 1.kilobyte
      MEGABYTE = 1.megabyte
      GIGABYTE = 1.gigabyte
      TERABYTE = 1.terabyte

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

      private

      def unsupported_unit!(unit)
        raise ArgumentError.new("Unsupported unit - #{ unit }")
      end
    end
  end
end
