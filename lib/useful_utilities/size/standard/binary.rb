module UsefulUtilities
  module Size
    module Standard
      module Binary
        # @note: used ISO standard http://en.wikipedia.org/wiki/Binary_prefix

        KIBI = 1024      # KiB
        MEBI = KIBI ** 2 # MiB
        GIBI = KIBI ** 3 # GiB
        TEBI = KIBI ** 4 # TiB

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
