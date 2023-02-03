require 'spec_helper'

describe UsefulUtilities::RedhatRelease do
  let(:service) { described_class.new(release_string) }

  let(:invalid_release) { 'foobar' }
  let(:centos_5_11) { 'CentOS release 5.11 (Final)' }
  let(:centos_6_8) { 'CentOS release 6.8 (Final)' }
  let(:centos_7_1_1503) { 'CentOS Linux release 7.1.1503 (Core)' }
  let(:rhel_5_11) { 'Red Hat Enterprise Linux Server release 5.11 (Tikanga)' }
  let(:rhel_6_8) { 'Red Hat Enterprise Linux Server release 6.8 (Santiago)' }
  let(:rhel_7_2) { 'Red Hat Enterprise Linux Server release 7.2 (Maipo)' }
  let(:vzlinux_9_0_1) { 'Virtuozzo Linux release 9.0.1 (Vz)' }

  describe '.legacy_distro' do
    let(:major_version) { 7 }

    subject { described_class.legacy_distro(major_version) }

    it { is_expected.to eq('centos7') }
  end

  describe '#major_version' do
    subject { service.major_version }

    context 'for nil release string' do
      let(:release_string) { nil }

      it { is_expected.to eq(6) } 
    end

    context 'for invalid release string' do
      let(:release_string) { invalid_release }

      it { is_expected.to eq(6) } 
    end
    
    context 'for CentOS 5.11' do
      let(:release_string) { centos_5_11 }

      it { is_expected.to eq(5) }
    end

    context 'for CentOS 6.8' do
      let(:release_string) { centos_6_8 }

      it { is_expected.to eq(6) }
    end

    context 'for CentOS 7.1.1503' do
      let(:release_string) { centos_7_1_1503 }

      it { is_expected.to eq(7) }
    end

    context 'for RHEL 5.11' do
      let(:release_string) { rhel_5_11 }

      it { is_expected.to eq(5) }
    end

    context 'for Virtuozzo Linux 9.0.1' do
      let(:release_string) { vzlinux_9_0_1 }

      it { is_expected.to eq(9) } 
    end
  end

  describe '#minor_version' do
    subject { service.minor_version }

    context 'for nil release string' do
      let(:release_string) { nil }

      it { is_expected.to eq(0) } 
    end

    context 'for invalid release string' do
      let(:release_string) { invalid_release }

      it { is_expected.to eq(0) } 
    end

    context 'for CentOS 5.11' do
      let(:release_string) { centos_5_11 }

      it { is_expected.to eq(11) }
    end

    context 'for CentOS 6.8' do
      let(:release_string) { centos_6_8 }

      it { is_expected.to eq(8) }
    end

    context 'for CentOS 7.1.1503' do
      let(:release_string) { centos_7_1_1503 }

      it { is_expected.to eq(1) }
    end

    context 'for RHEL 5.11' do
      let(:release_string) { rhel_5_11 }

      it { is_expected.to eq(11) }
    end

    context 'for Virtuozzo Linux 9.0.1' do
      let(:release_string) { vzlinux_9_0_1 }

      it { is_expected.to eq(0) } 
    end
  end

  describe '#patch_version' do
    subject { service.patch_version }

    context 'for nil release string' do
      let(:release_string) { nil }

      it { is_expected.to be_nil } 
    end

    context 'for invalid release string' do
      let(:release_string) { invalid_release }

      it { is_expected.to be_nil } 
    end

    context 'for CentOS 5.11' do
      let(:release_string) { centos_5_11 }

      it { is_expected.to be_nil }
    end

    context 'for CentOS 6.8' do
      let(:release_string) { centos_6_8 }

      it { is_expected.to be_nil }
    end

    context 'for CentOS 7.1.1503' do
      let(:release_string) { centos_7_1_1503 }

      it { is_expected.to eq(1503) }
    end

    context 'for RHEL 5.11' do
      let(:release_string) { rhel_5_11 }

      it { is_expected.to be_nil }
    end

    context 'for Virtuozzo Linux 9.0.1' do
      let(:release_string) { vzlinux_9_0_1 }

      it { is_expected.to eq(1) } 
    end
  end

  describe '#version_string' do
    subject { service.version_string }

    context 'for nil release string' do
      let(:release_string) { nil }

      it { is_expected.to eq('6.0') } 
    end

    context 'for invalid release string' do
      let(:release_string) { invalid_release }

      it { is_expected.to eq('6.0') }
    end

    context 'for CentOS 5.11' do
      let(:release_string) { centos_5_11 }

      it { is_expected.to eq('5.11') }
    end

    context 'for CentOS 6.8' do
      let(:release_string) { centos_6_8 }

      it { is_expected.to eq('6.8') }
    end

    context 'for CentOS 7.1.1503' do
      let(:release_string) { centos_7_1_1503 }

      it { is_expected.to eq('7.1.1503') }
    end

    context 'for RHEL 5.11' do
      let(:release_string) { rhel_5_11 }

      it { is_expected.to eq('5.11') }
    end

    context 'for RHEL 6.8' do
      let(:release_string) { rhel_6_8 }

      it { is_expected.to eq('6.8') }
    end

    context 'for RHEL 7.2' do
      let(:release_string) { rhel_7_2 }

      it { is_expected.to eq('7.2') }
    end

    context 'for Virtuozzo Linux 9.0.1' do
      let(:release_string) { vzlinux_9_0_1 }

      it { is_expected.to eq('9.0.1') }
    end
  end
end
