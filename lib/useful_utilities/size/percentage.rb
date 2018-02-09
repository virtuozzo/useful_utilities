module UsefulUtilities
  module Size
    module Percentage
      HUNDRED = 100

      def fraction_to_percentage(fraction)
        fraction * HUNDRED
      end

      def percentage_to_fraction(percentage)
        percentage.fdiv(HUNDRED)
      end
    end
  end
end
