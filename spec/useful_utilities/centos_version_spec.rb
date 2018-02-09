require 'spec_helper'

describe UsefulUtilities::CentOSVersion do
  let(:service) { described_class.new(version) }

  describe '#centos7?' do
    subject { service.centos7? }

    context 'version == 5' do
      let(:version) { 5 }

      it { is_expected.to be false }
    end

    context 'version == 7' do
      let(:version) { 7 }

      it { is_expected.to be true }
    end
  end

  describe '#not_centos5?' do
    subject { service.not_centos5? }

    context 'version == 5' do
      let(:version) { 5 }

      it { is_expected.to be false }
    end

    context 'version == 7' do
      let(:version) { 7 }

      it { is_expected.to be true }
    end
  end

  describe '.centos7?' do
    subject { described_class.centos7?(version) }

    context 'version == 5' do
      let(:version) { 5 }

      it { is_expected.to be false }
    end

    context 'version == 7' do
      let(:version) { 7 }

      it { is_expected.to be true }
    end
  end

  describe '.not_centos5?' do
    subject { described_class.not_centos5?(version) }

    context 'version == 5' do
      let(:version) { 5 }

      it { is_expected.to be false }
    end

    context 'version 7' do
      let(:version) { 7 }

      it { is_expected.to be true }
    end
  end
end
