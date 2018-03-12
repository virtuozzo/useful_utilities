module UsefulUtilities
  module Size
    # Percentage utilities
    module Percentage
      HUNDRED = 100

      # @param fraction [Numeric]
      # @return [Numeric] fraction converted to percentage
      def fraction_to_percentage(fraction)
        fraction * HUNDRED
      end

      # @param percentage [Numeric]
      # @return [Float] percentage converted to fraction
      def percentage_to_fraction(percentage)
        percentage.fdiv(HUNDRED)
      end
    end
  end
end
