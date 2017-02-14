require 'spec_helper'

describe Utils::Size::Frequency do
  include described_class

  context '.to_gigahertz' do
    specify { expect(to_gigahertz(1000**3,  :Hz)).to  eq 1.0 }
    specify { expect(to_gigahertz(1000**2,  :KHz)).to eq 1.0 }
    specify { expect(to_gigahertz(1000,     :MHz)).to eq 1.0 }
    specify { expect(to_gigahertz(1   ,     :GHz)).to eq 1.0 }
    specify { expect(to_gigahertz(1.0/1000, :THz)).to eq 1.0 }
    specify { expect { to_gigahertz(4, :KB) }.to raise_error(ArgumentError) }
  end

  context '.to_megahertz' do
    specify { expect(to_megahertz(1000**2,     :Hz)).to  eq 1.0 }
    specify { expect(to_megahertz(1000,        :KHz)).to eq 1.0 }
    specify { expect(to_megahertz(1,           :MHz)).to eq 1.0 }
    specify { expect(to_megahertz(1.0/1000,    :GHz)).to eq 1.0 }
    specify { expect(to_megahertz(1.0/1000**2, :THz)).to eq 1.0 }
    specify { expect { to_megahertz(4, :KB) }.to raise_error(ArgumentError) }
  end
end
