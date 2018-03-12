require_relative 'standard/binary'

module UsefulUtilities
  module Size
    # Possible units:
    #   :B  - bytes
    #   :KB - kilobytes
    #   :MB - megabytes
    #   :GB - gigabytes
    #   :TB - terabytes
    # Used ISO standard http://en.wikipedia.org/wiki/Binary_prefix
    #   Binary
    #   1 K = 1024
    module Byte
      include UsefulUtilities::Size::Standard::Binary

      HALF_OF_SECTOR = 0.5

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in terabytes
      def to_terabytes(size, unit)
        to_tebi(size, byte_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in gigabytes
      def to_gigabytes(size, unit)
        to_gibi(size, byte_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in megabytes
      def to_megabytes(size, unit)
        to_mebi(size, byte_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in kilobytes
      def to_kilobytes(size, unit)
        if unit == :sector
          return (size * HALF_OF_SECTOR).round # http://en.wikipedia.org/wiki/Disk_sector
        end

        to_kibi(size, byte_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @return [Numeric] size in bytes
      def to_bytes(size, unit)
        to_binary_bi(size, byte_prefix(unit))
      end

      # @param size [Numeric]
      # @param unit [Symbol]
      # @param rounder [Integer]
      # @return [Numeric] humanized size in provided unit
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
