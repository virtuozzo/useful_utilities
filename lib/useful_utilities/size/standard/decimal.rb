module UsefulUtilities
  module Size
    module Standard
      # Used SI standard http://en.wikipedia.org/wiki/Binary_prefix
      module Decimal

        KILO = 1000      # KB
        MEGA = KILO ** 2 # MB
        GIGA = KILO ** 3 # GB
        TERA = KILO ** 4 # TB

        def to_tera(val, prefix)
          case prefix
          when :B  then val.fdiv(TERA)
          when :KB then val.fdiv(GIGA)
          when :MB then val.fdiv(MEGA)
          when :GB then val.fdiv(KILO)
          when :TB then val
          else unsupported_unit!(prefix)
          end
        end

        def to_giga(val, prefix)
          case prefix
          when :B  then val.fdiv(GIGA)
          when :KB then val.fdiv(MEGA)
          when :MB then val.fdiv(KILO)
          when :GB then val
          when :TB then val * KILO
          else unsupported_unit!(prefix)
          end
        end

        def to_mega(val, prefix)
          case prefix
          when :B  then val.fdiv(MEGA)
          when :KB then val.fdiv(KILO)
          when :MB then val
          when :GB then val * KILO
          when :TB then val * MEGA
          else unsupported_unit!(prefix)
          end
        end

        def to_kilo(val, prefix)
          case prefix
          when :B  then val.fdiv(KILO)
          when :KB then val
          when :MB then val * KILO
          when :GB then val * MEGA
          when :TB then val * GIGA
          else unsupported_unit!(prefix)
          end
        end

        def to_decimal_bi(val, prefix)
          case prefix
          when :B  then val
          when :KB then val * KILO
          when :MB then val * MEGA
          when :GB then val * GIGA
          when :TB then val * TERA
          else unsupported_unit!(prefix)
          end
        end
      end
    end
  end
end
