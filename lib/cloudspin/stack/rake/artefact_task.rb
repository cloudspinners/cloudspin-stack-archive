module Cloudspin
  module Stack
    module Rake

      class ArtefactTask < ::Rake::TaskLib

        def initialize(definition_folder:, dist_folder:)
          @definition_folder = definition_folder
          @dist_folder = dist_folder
          define
        end

        def define
          desc 'Assemble files to be packaged'
          task :build, [:test_folder, :environments_folder, :instance_defaults_file] do |t, args|
            add_folder(args[:test_folder] || './test')
            add_folder(args[:environments_folder] || './environments')
            add_file(args[:instance_defaults_file] || './stack-instance-defaults.yaml')
            add_file('Rakefile') if File.exists? 'Rakefile'
            builder.build
          end

          desc 'Package the artefact'
          task :package do |t, args|
            builder.package
          end
        end

        def add_folder(folder)
          builder.add_folder_to_package(folder) if Dir.exists?(folder)
        end

        def add_file(filename)
          builder.add_file_to_package(filename) if File.exists?(filename)
        end

        def builder
          @builder ||= Cloudspin::Stack::Artefact::Builder.new(
            stack_definition: stack_definition,
            dist_folder: @dist_folder
          )
        end

        def stack_definition
          @definition ||= Cloudspin::Stack::Definition.from_file(@definition_folder + '/stack-definition.yaml')
        end

      end
    end
  end
end

