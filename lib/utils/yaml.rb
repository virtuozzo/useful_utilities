# It was used in outdated rake task, but we decided to leave for the future
module Utils
  module YAML
    extend self

    def rename_keys(file_path, key_map)
      yaml_hash = ::YAML.load_file(file_path)
      keys_to_rename = yaml_hash.keys & key_map.keys

      return if keys_to_rename.empty?

      keys_to_rename.each { |old_key| yaml_hash[key_map.fetch(old_key)] = yaml_hash.delete(old_key) }

      File.open(file_path, 'w') { |file| ::YAML.dump(yaml_hash, file) }
    end
  end
end
