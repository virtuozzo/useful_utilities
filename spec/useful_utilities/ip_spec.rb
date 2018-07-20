require 'spec_helper'

describe UsefulUtilities::IP do
  describe '.valid_ip?' do
    context 'valid ip address version 4' do
      it { expect(described_class.valid_ip?('10.10.10.10')).to eq(true) }
    end

    context 'valid ip address version 6' do
      specify do
        expect(described_class.valid_ip?('fe80::712f:f11a:d6d8:c980')).to eq(true)
      end
    end

    context 'non-parsable ip address' do
      specify do
        expect(described_class.valid_ip?('non-parsable ip address')).to eq(false)
      end
    end
  end

  describe '.private?' do
    context 'private ip addresses' do
      [
        '10.0.0.0',
        '10.255.255.255',
        '172.16.0.0',
        '172.31.255.255',
        '192.168.0.0',
        '192.168.255.255',
        'fc00::',
        'fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'
      ].each do |ip|
        context ip do
          it { expect(described_class.private_ip?(ip)).to eq(true) }
        end
      end
    end

    context 'not private ip addresses' do
      [
        '0.0.0.0',
        '9.255.255.255',
        '11.0.0.0',
        '172.15.255.255',
        '172.32.0.0',
        '192.167.255.255',
        '192.169.0.0',
        '255.255.255.255',
        '::',
        'fe00::',
        'fbff:ffff:ffff:ffff:ffff:ffff:ffff:ffff',
        'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'
      ].each do |ip|
        context ip do
          it { expect(described_class.private_ip?(ip)).to eq(false) }
        end
      end
    end
  end

  describe '.integer_to_ip_string' do
    subject { described_class.integer_to_ip_string(address, version: version) }

    context 'minimum ipv4 number' do
      let(:address) { 0 }
      let(:version) { 4 }

      it { is_expected.to eq('0.0.0.0') }
    end

    context 'maximum ipv4 number' do
      let(:address) { 4294967295 }
      let(:version) { 4 }

      it { is_expected.to eq('255.255.255.255') }
    end

    context 'minimum ipv6 number' do
      let(:address) { 0 }
      let(:version) { 6 }

      it { is_expected.to eq('::') }
    end

    context 'maximum ipv6 number' do
      let(:address) { 340282366920938463463374607431768211455 }
      let(:version) { 6 }

      it { is_expected.to eq('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff') }
    end

    context 'wrong version (not 4 or 6) supplied' do
      let(:address) { 0 }
      let(:version) { 5 }
      let(:error_message) do
        'Unsupported ip address version! '\
        'Supported argument values: 4 or 6.'
      end

      it { expect { subject }.to raise_error(ArgumentError, error_message) }
    end

    context 'number bigger than allowed' do
      context 'ipv4' do
        let(:address) { 4294967296 } # IPAddr.new('255.255.255.255').to_i + 1
        let(:version) { 4 }
        let(:error_message) { 'Invalid address!' }

        it { expect { subject }.to raise_error(ArgumentError, error_message) }
      end

      context 'ipv6' do
        # IPAddr.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').to_i + 1
        let(:address) { 340282366920938463463374607431768211456 }
        let(:version) { 6 }
        let(:error_message) { 'Invalid address!' }

        it { expect { subject }.to raise_error(ArgumentError, error_message) }
      end
    end

    context 'address less than zero' do
      let(:address) { -1 }
      let(:error_message) { 'Invalid address!' }

      context 'ipv4' do
        let(:version) { 4 }

        it { expect { subject }.to raise_error(ArgumentError, error_message) }
      end

      context 'ipv6' do
        let(:version) { 6 }

        it { expect { subject }.to raise_error(ArgumentError, error_message) }
      end
    end

    context 'address not integer' do
      let(:address) { 'non-integer value' }
      let(:error_message) { 'Supplied address is not integer!' }

      context 'ipv4' do
        let(:version) { 4 }

        it { expect { subject }.to raise_error(ArgumentError, error_message) }
      end

      context 'ipv6' do
        let(:version) { 6 }

        it { expect { subject }.to raise_error(ArgumentError, error_message) }
      end
    end
  end

  describe '.ip_string_to_integer' do
    context 'valid ip string supplied' do
      it { expect(described_class.ip_string_to_integer('0.0.0.1')).to eq(1) }
      it { expect(described_class.ip_string_to_integer('::1')).to eq(1) }
    end

    context 'non-parsable ip string' do
      specify do
        expect { described_class.ip_string_to_integer('non-parsable ip') }
          .to raise_error(ArgumentError, 'Invalid ip address string supplied!')
      end
    end
  end

  describe '.ip_string_to_integer_with_version' do
    context 'valid ip string supplied' do
      specify do
        expect(described_class.ip_string_to_integer_with_version('0.0.0.1'))
          .to eq([1, 4])
      end

      specify do
        expect(described_class.ip_string_to_integer_with_version('::1'))
          .to eq([1, 6])
      end
    end

    context 'version' do
      context 'ipv4' do
        before do
          allow_any_instance_of(IPAddr).to receive(:ipv4?).and_return(true)
          allow_any_instance_of(IPAddr).to receive(:ipv6?).and_return(false)
        end

        specify do
          expect(described_class.ip_string_to_integer_with_version('0.0.0.1')[1])
            .to eq(4)
        end
      end

      context 'ipv6' do
        before do
          allow_any_instance_of(IPAddr).to receive(:ipv4?).and_return(false)
          allow_any_instance_of(IPAddr).to receive(:ipv6?).and_return(true)
        end

        specify do
          expect(described_class.ip_string_to_integer_with_version('::1')[1])
            .to eq(6)
        end
      end

      context 'not ipv4 and not ipv6' do
        before do
          allow_any_instance_of(IPAddr).to receive(:ipv4?).and_return(false)
          allow_any_instance_of(IPAddr).to receive(:ipv6?).and_return(false)
        end

        specify do
          expect(described_class.ip_string_to_integer_with_version('::1')[1])
            .to be_nil
        end
      end
    end

    context 'non-parsable ip string' do
      specify do
        expect { described_class.ip_string_to_integer('non-parsable ip') }
          .to raise_error(ArgumentError, 'Invalid ip address string supplied!')
      end
    end
  end

  describe '.acceptable_network_mask?' do
    subject { described_class.acceptable_network_mask?(network_mask, version: version) }

    context 'version: 4' do
      let(:version) { 4 }

      context 'network_mask is not integer' do
        let(:network_mask) { 'non-integer' }

        it { is_expected.to eq(false) }
      end

      context 'minimum network_mask' do
        let(:network_mask) { 0 }

        it { is_expected.to eq(true) }
      end

      context 'maximum network_mask' do
        let(:network_mask) { 32 }

        it { is_expected.to eq(true) }
      end

      context 'bigger than  maximum network_mask' do
        let(:network_mask) { 33 }

        it { is_expected.to eq(false) }
      end

      context 'less than minimum network_mask' do
        let(:network_mask) { -1 }

        it { is_expected.to eq(false) }
      end
    end

    context 'version: 6' do
      let(:version) { 6 }

      context 'network_mask is not integer' do
        let(:network_mask) { 'non-integer' }

        it { is_expected.to eq(false) }
      end

      context 'minimum network_mask' do
        let(:network_mask) { 0 }

        it { is_expected.to eq(true) }
      end

      context 'maximum network_mask' do
        let(:network_mask) { 128 }

        it { is_expected.to eq(true) }
      end

      context 'bigger than  maximum network_mask' do
        let(:network_mask) { 129 }

        it { is_expected.to eq(false) }
      end

      context 'less than minimum network_mask' do
        let(:network_mask) { -1 }

        it { is_expected.to eq(false) }
      end
    end

    context 'raise error if wrong version (not 4 or 6) supplied' do
      let(:version) { 5 }
      let(:network_mask) { 0 }
      let(:error_message) do
        'Unsupported version supplied! Supported version values: 4 or 6.'
      end

      specify do
        expect { subject }.to raise_error(ArgumentError, error_message)
      end
    end
  end

  describe '.network_address' do
    subject { described_class.network_address(ip_string, network_mask) }

    context 'return proper network address' do
      specify do
        expect(described_class.network_address('10.10.10.10', 24))
          .to eq('10.10.10.0')
      end

      specify do
        expect(described_class.network_address('ffff:f0f0:ffff:ffff:ffff:ffff:ffff:ffff', 96))
          .to eq('ffff:f0f0:ffff:ffff:ffff:ffff::')
      end
    end

    context 'raise error if network_mask is not acceptable' do
      let(:error_message) do
        "Invalid network mask: '33' for address: '10.10.10.10'"
      end

      specify do
        expect { described_class.network_address('10.10.10.10', 33) }
          .to raise_error(ArgumentError, error_message)
      end
    end

    context 'raise error if ip version neither 4 no 6' do
      let(:error_message) { 'Unsupported ip address version!' }

      before do
        allow_any_instance_of(IPAddr).to receive(:ipv4?).and_return(false)
        allow_any_instance_of(IPAddr).to receive(:ipv6?).and_return(false)
      end

      specify do
        expect { described_class.network_address('10.10.10.10', 24) }
          .to raise_error(ArgumentError, error_message)
      end
    end
  end
end
