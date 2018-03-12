module UsefulUtilities
  module Size
    module Standard
      # Possible prefixes:
      #   :B   - bytes
      #   :KiB - kibibytes
      #   :MiB - mebibytes
      #   :GiB - gibibytes
      #   :TiB - tebibytes
      # Used ISO standard http://en.wikipedia.org/wiki/Binary_prefix
      module Binary

        KIBI = 1024      # KiB
        MEBI = KIBI ** 2 # MiB
        GIBI = KIBI ** 3 # GiB
        TEBI = KIBI ** 4 # TiB

        # @param val [Numeric]
        # @param prefix [Symbol]
        # @return [Numeric] val in tebibytes
        def to_tebi(val, prefix)
          case prefix
          when :B   then val.fdiv(TEBI)
          when :KiB then val.fdiv(GIBI)
          when :MiB then val.fdiv(MEBI)
          when :GiB then val.fdiv(KIBI)
          when :TiB then val
          else unsupported_unit!(prefix)
          end
        end

        # @param val [Numeric]
        # @param prefix [Symbol]
        # @return [Numeric] val in gibibytes
        def to_gibi(val, prefix)
          case prefix
          when :B   then val.fdiv(GIBI)
          when :KiB then val.fdiv(MEBI)
          when :MiB then val.fdiv(KIBI)
          when :GiB then val
          when :TiB then val * KIBI
          else unsupported_unit!(prefix)
          end
        end

        # @param val [Numeric]
        # @param prefix [Symbol]
        # @return [Numeric] val in mebibytes
        def to_mebi(val, prefix)
          case prefix
          when :B   then val.fdiv(MEBI)
          when :KiB then val.fdiv(KIBI)
          when :MiB then val
          when :GiB then val * KIBI
          when :TiB then val * MEBI
          else unsupported_unit!(prefix)
          end
        end

        # @param val [Numeric]
        # @param prefix [Symbol]
        # @return [Numeric] val in kibibytes
        def to_kibi(val, prefix)
          case prefix
          when :B   then val.fdiv(KIBI)
          when :KiB then val
          when :MiB then val * KIBI
          when :GiB then val * MEBI
          when :TiB then val * GIBI
          else unsupported_unit!(prefix)
          end
        end

        # @param val [Numeric]
        # @param prefix [Symbol]
        # @return [Numeric] val in bytes
        def to_binary_bi(val, prefix)
          case prefix
          when :B   then val
          when :KiB then val * KIBI
          when :MiB then val * MEBI
          when :GiB then val * GIBI
          when :TiB then val * TEBI
          else unsupported_unit!(prefix)
          end
        end
      end
    end
  end
end
