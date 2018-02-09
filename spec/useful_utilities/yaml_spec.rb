require 'spec_helper'

describe UsefulUtilities::YAML do
  describe '.rename_keys' do
    let(:file_path) { Rails.root.join('..', 'fixtures', 'test_on_app.yml') }
    let(:yaml_hash) { ::YAML.load_file(file_path) }

    let(:initial_yaml_hash) do
      {
        'key_1'     => '1',
        'key_2'     => '2',
        'old_key_1' => 'old_value_1',
        'old_key_2' => 'old_value_2'
      }
    end

    let(:updated_yaml_hash) do
      {
        'key_1'     => '1',
        'key_2'     => '2',
        'new_key_1' => 'old_value_1',
        'new_key_2' => 'old_value_2'
      }
    end


    before do
      File.open(file_path, 'w') { |f| ::YAML.dump(initial_yaml_hash, f) }

      described_class.rename_keys(file_path, key_map)
    end

    after do
      File.delete(file_path)
    end

    context 'a file has keys to rename' do
      let(:key_map) do
        {
          'old_key_1'          => 'new_key_1',
          'old_key_2'          => 'new_key_2',
          'non_existing_key_1' => 'non_existing_value_1'
        }
      end

      it 'renames the file with new keys' do
        expect(yaml_hash).to eq updated_yaml_hash
      end
    end

    context 'a file does not have keys to rename' do
      let(:key_map) do
        {
          'non_existing_key_1' => 'non_existing_value_1',
          'non_existing_key_2' => 'non_existing_value_2'
        }
      end

      it 'does not rename the file' do
        expect(yaml_hash).to eq initial_yaml_hash
      end
    end
  end
end
