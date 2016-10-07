require 'spec_helper'

describe Utils::Size do
  include described_class

  context '.to_terabytes' do
    specify { expect(to_terabytes(1024**4, :B)).to  eq 1.0 }
    specify { expect(to_terabytes(1024**3, :KB)).to eq 1.0 }
    specify { expect(to_terabytes(1024**2, :MB)).to eq 1.0 }
    specify { expect(to_terabytes(1024,    :GB)).to eq 1.0 }
    specify { expect(to_terabytes(1,       :TB)).to eq 1.0 }
    specify { expect { to_terabytes(4, :KiB) }.to raise_error(ArgumentError) }
  end

  context '.to_gigabytes' do
    specify { expect(to_gigabytes(1024**3,  :B)).to  eq 1.0 }
    specify { expect(to_gigabytes(1024**2,  :KB)).to eq 1.0 }
    specify { expect(to_gigabytes(1024,     :MB)).to eq 1.0 }
    specify { expect(to_gigabytes(1   ,     :GB)).to eq 1.0 }
    specify { expect(to_gigabytes(1.0/1024, :TB)).to eq 1.0 }
    specify { expect { to_gigabytes(4, :KiB) }.to raise_error(ArgumentError) }
  end

  context '.to_megabytes' do
    specify { expect(to_megabytes(1024**2,     :B)).to  eq 1.0 }
    specify { expect(to_megabytes(1024,        :KB)).to eq 1.0 }
    specify { expect(to_megabytes(1,           :MB)).to eq 1.0 }
    specify { expect(to_megabytes(1.0/1024,    :GB)).to eq 1.0 }
    specify { expect(to_megabytes(1.0/1024**2, :TB)).to eq 1.0 }
    specify { expect { to_megabytes(4, :KiB) }.to raise_error(ArgumentError) }
  end

  context '.to_kilobytes' do
    specify { expect(to_kilobytes(1024,        :B)).to  eq 1.0 }
    specify { expect(to_kilobytes(1,           :KB)).to eq 1.0 }
    specify { expect(to_kilobytes(1.0/1024,    :MB)).to eq 1.0 }
    specify { expect(to_kilobytes(1.0/1024**2, :GB)).to eq 1.0 }
    specify { expect(to_kilobytes(1.0/1024**3, :TB)).to eq 1.0 }
    specify { expect(to_kilobytes(2047, :sector)).to eq 1024 }
    specify { expect { to_kilobytes(4, :KiB) }.to raise_error(ArgumentError) }
  end

  context '.to_bytes' do
    specify { expect(to_bytes(1,           :B)).to  eq 1.0 }
    specify { expect(to_bytes(1.0/1024,    :KB)).to eq 1.0 }
    specify { expect(to_bytes(1.0/1024**2, :MB)).to eq 1.0 }
    specify { expect(to_bytes(1.0/1024**3, :GB)).to eq 1.0 }
    specify { expect(to_bytes(1.0/1024**4, :TB)).to eq 1.0 }
    specify { expect { to_bytes(4, :GiB) }.to raise_error(ArgumentError) }
  end

  context '.bytes_to_human_size' do
    context 'with default rounder' do
      specify { expect(bytes_to_human_size(1       + 0.001, :B)).to  eq 1.001 }
      specify { expect(bytes_to_human_size(1024    + 1,     :KB)).to eq 1.001 }
      specify { expect(bytes_to_human_size(1024**2 + 10**3, :MB)).to eq 1.001 }
      specify { expect(bytes_to_human_size(1024**3 + 10**6, :GB)).to eq 1.001 }
      specify { expect(bytes_to_human_size(1024**4 + 10**9, :TB)).to eq 1.001 }
    end

    context 'with custom rounder' do
      specify { expect(bytes_to_human_size(1       + 0.11111,     :B,  1)).to eq 1.1 }
      specify { expect(bytes_to_human_size(1024    + 11111/10**3, :KB, 2)).to eq 1.01 }
      specify { expect(bytes_to_human_size(1024**2 + 11111/10,    :MB, 3)).to eq 1.001 }
      specify { expect(bytes_to_human_size(1024**3 + 11111*10,    :GB, 4)).to eq 1.0001 }
      specify { expect(bytes_to_human_size(1024**4 + 11111*10**3, :TB, 5)).to eq 1.00001 }
    end
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
