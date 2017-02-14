require 'utils/size/standard/binary'

module Utils
  module Size
    module Byte
      # @note: used ISO standard http://en.wikipedia.org/wiki/Binary_prefix
      #   Binary
      #   1 kilobyte = 1024 byte
      include Utils::Size::Standard::Binary

      HALF_OF_SECTOR = 0.5

      def to_terabytes(size, unit)
        to_tebi(size, byte_prefix(unit))
      end

      def to_gigabytes(size, unit)
        to_gibi(size, byte_prefix(unit))
      end

      def to_megabytes(size, unit)
        to_mebi(size, byte_prefix(unit))
      end

      def to_kilobytes(size, unit)
        if unit == :sector
          return (size * HALF_OF_SECTOR).round # http://en.wikipedia.org/wiki/Disk_sector
        end

        to_kibi(size, byte_prefix(unit))
      end

      def to_bytes(size, unit)
        to_binary_bi(size, byte_prefix(unit))
      end

      # Convert bytes to manually defined format
      #   by using parameter 'unit'
      #   ATTENTION: by default round is eq to 3 digits
      def bytes_to_human_size(size, unit, rounder = 3)
        case unit
        when :B  then size.round(rounder)
        when :KB then to_kilobytes(size, :B).round(rounder)
        when :MB then to_megabytes(size, :B).round(rounder)
        when :GB then to_gigabytes(size, :B).round(rounder)
        when :TB then to_terabytes(size, :B).round(rounder)
        else  unsupported_unit!(unit)
        end
      end

      private

      def byte_prefix(unit)
        case unit
        when :B  then :B
        when :KB then :KiB
        when :MB then :MiB
        when :GB then :GiB
        when :TB then :TiB
        else unsupported_unit!(unit)
        end
      end

      def unsupported_unit!(unit)
        raise ArgumentError.new("Unsupported unit - #{ unit }")
      end
    end
  end
end
