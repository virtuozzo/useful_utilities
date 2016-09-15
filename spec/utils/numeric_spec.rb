require 'spec_helper'

describe Utils::Numeric do
  context '.positive_or_zero' do
    specify { expect(described_class.positive_or_zero(3)).to eq 3 }
    specify { expect(described_class.positive_or_zero(-4)).to be_zero }
  end

  context '.to_kilo' do
    specify { expect(described_class.to_kilo(300, :G)).to eq 300_000_000 }
    specify { expect(described_class.to_kilo(124, :M)).to eq 124_000 }
    specify { expect { described_class.to_kilo(12, :L) }.to raise_error(ArgumentError) }
  end

  context '.to_giga' do
    specify { expect(described_class.to_giga(123456, :k)).to eq 0.123456 }
    specify { expect(described_class.to_giga(425632, :M)).to eq 425.632 }
    specify { expect { described_class.to_giga(32, :L) }.to raise_error(ArgumentError) }
  end

  context '.to_number' do
    specify { expect(described_class.to_number(2.5, :M)).to eq 2_500_000 }
    specify { expect(described_class.to_number(0.5, :G)).to eq 500_000_000 }
    specify { expect { described_class.to_number(32, :L) }.to raise_error(ArgumentError) }
  end
end
