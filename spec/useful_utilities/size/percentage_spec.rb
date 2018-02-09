require 'spec_helper'

describe UsefulUtilities::Size::Percentage do
  include described_class

  context '.fraction_to_percentage' do
    specify { expect(fraction_to_percentage(0.3)).to eq 30 }
  end

  context '.percentage_to_fraction' do
    specify { expect(percentage_to_fraction(30)).to eq 0.3 }
  end
end
