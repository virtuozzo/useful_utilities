require 'spec_helper'

describe Utils::Size do
  include described_class

  context '.to_cdn_gigabytes' do
    specify { expect(to_cdn_gigabytes(121248.05, :Mbit)).to eq 15.15600625 }
  end

  context '.to_gigahertz' do
    specify { expect(to_gigahertz(1078, :MHz)).to eq 1.078 }
    specify { expect { to_gigahertz(1024, :MB) }.to raise_error(ArgumentError) }
  end

  context '.to_megahertz' do
    specify { expect(to_megahertz(42, :Hz)).to eq 0.000042 }
    specify { expect(to_megahertz(42, :KHz)).to eq 0.042 }
    specify { expect(to_megahertz(42, :GHz)).to eq 42000 }
    specify { expect { to_megahertz(42, :MB) }.to raise_error(ArgumentError) }
  end

  context '.fraction_to_percentage' do
    specify { expect(fraction_to_percentage(0.3)).to eq 30 }
  end
end
