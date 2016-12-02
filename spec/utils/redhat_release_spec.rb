require 'spec_helper'

describe Utils::RedhatRelease do
  let(:service) { described_class.new(release_string) }

  describe '.legacy_distro' do
    let(:major_version) { 7 }

    subject { described_class.legacy_distro(major_version) }

    it { is_expected.to eq 'centos7' }
  end

  describe '#major_version' do
    subject { service.major_version }

    context 'new versioning format(for versions >= 7.x.x)' do
      let(:release_string) { 'CentOS Linux release 7.1.1503 (Core)' }

      it { is_expected.to eq 7 }
    end

    context 'old versioning format(for Centos/RHEL release versions < 7.0.x)' do
      let(:release_string) { 'CentOS release 5.11 (Final)' }

      it { is_expected.to eq 5 }
    end
  end

  describe '#minor_version' do
    subject { service.minor_version }

    context 'new versioning format(for Centos versions >= 7.x.x)' do
      let(:release_string) { 'CentOS Linux release 7.1.1503 (Core)' }

      it { is_expected.to eq 1 }
    end

    context 'old versioning format(for Centos release versions < 7.0.x and any RHEL ver.)' do
      let(:release_string) { 'CentOS release 5.11 (Final)' }

      it { is_expected.to eq 11 }
    end
  end

  describe '#monthstamp' do
    subject { service.monthstamp }

    context 'new versioning format(for versions >= 7.x.x)' do
      let(:release_string) { 'CentOS Linux release 7.1.1503 (Core)' }

      it { is_expected.to eq 1503 }
    end

    context 'old versioning format(for Centos/RHEL release versions < 7.0.x)' do
      let(:release_string) { 'CentOS release 5.11 (Final)' }

      it { is_expected.to be_nil }
    end
  end

  describe '#version_string' do
    subject { service.version_string }

    context 'Centos release version 5.x' do
      let(:release_string) { 'CentOS release 5.11 (Final)' }

      it { is_expected.to eq '5.11' }
    end

    context 'RHEL release version 5.x' do
      let(:release_string) { 'Red Hat Enterprise Linux Server release 5.11 (Tikanga)' }

      it { is_expected.to eq '5.11' }
    end

    context 'Centos release version 6.x' do
      let(:release_string) { 'CentOS release 6.8 (Final)' }

      it { is_expected.to eq '6.8' }
    end

    context 'RHEL release version 6.x' do
      let(:release_string) {  'Red Hat Enterprise Linux Server release 6.8 (Santiago)' }

      it { is_expected.to eq '6.8' }
    end

    context 'Centos release version 7.x.x' do
      let(:release_string) { 'CentOS Linux release 7.2.1511 (Core)' }

      it { is_expected.to eq '7.2.1511' }
    end

    context 'RHEL release version 7.x' do
      let(:release_string) { 'Red Hat Enterprise Linux Server release 7.2 (Maipo)' }

      it { is_expected.to eq '7.2' }
    end
  end

  describe '#version_arr' do
    subject(:version_arr) { service.send(:version_arr) }

    context 'Blank or invalid "release_string" is provided' do
      let(:release_string) { nil }

      it 'return default version array which corresponds to version 6.0' do
        expect(version_arr).to eq [6, 0]
      end
    end

    context 'Valid "release_string" is provided' do
      let(:release_string) { 'CentOS Linux release 7.1.1503 (Core)' }

      it 'return version array build from regex version match' do
        expect(version_arr).to eq [7, 1, 1503]
      end
    end
  end
end
