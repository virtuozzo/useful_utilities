require 'spec_helper'

describe Utils::Size do
  include described_class

  context '.to_gigabytes' do
    specify { expect(to_gigabytes(1600, :MB)).to eq 1.5625 }
    specify { expect(to_gigabytes(569376.768, :KB)).to eq 0.543 }
    specify { expect { to_gigabytes(4, :KiB) }.to raise_error(ArgumentError) }
  end

  context '.to_megabytes' do
    specify { expect(to_megabytes(2621440, :B)).to eq 2.5 }
    specify { expect(to_megabytes(3584, :KB)).to eq 3.5 }
    specify { expect(to_megabytes(2.4, :GB)).to eq 2457.6 }
    specify { expect { to_megabytes(4, :KiB) }.to raise_error(ArgumentError) }
  end

  context '.to_kilobytes' do
    specify { expect(to_kilobytes(1.2, :GB)).to eq 1258291.2 }
    specify { expect(to_kilobytes(5.2, :MB)).to eq 5324.8 }
    specify { expect(to_kilobytes(326_682_624, :B)).to eq 319026 }
    specify { expect(to_kilobytes(2047, :sector)).to eq 1024 }
    specify { expect { to_kilobytes(4, :KiB) }.to raise_error(ArgumentError) }
  end

  context '.to_bytes' do
    specify { expect(to_bytes(2.5, :GB)).to eq 2684354560 }
    specify { expect { to_bytes(4, :GiB) }.to raise_error(ArgumentError) }
  end

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
