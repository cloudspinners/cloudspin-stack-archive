
RSpec.describe Cloudspin::Stack::Rake::ArtefactTask do

  describe 'instantiate a task object' do

    let(:tmp_folder) {
      Dir.mktmpdir(['cloudspin-', '-source'])
    }

    let(:definition_folder) {
      yaml_file = File.open("#{tmp_folder}/stack-definition.yaml", 'w') { |file|
        file.write(<<~YAML_FILE
          ---
          stack:
            name: yaml_name
            version: 0.0.0-y
          YAML_FILE
        )
      }
      tmp_folder
    }

    let(:task) {
      Cloudspin::Stack::Rake::ArtefactTask.new(
        definition_folder: definition_folder,
        dist_folder: '/some/path/dist'
      )
    }

    it 'is created without error' do
      expect { task }.not_to raise_error
    end

  end

end
