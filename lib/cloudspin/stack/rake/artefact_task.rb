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
          task :build, [:inspec_folder, :config_file] do |t, args|
            add_folder(args[:inspec_folder] || './inspec')
            add_file(args[:config_file] || './spin-default.yaml')
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
          @definition ||= Cloudspin::Stack::Definition.from_file(@definition_folder + '/stack.yaml')
        end

      end
    end
  end
end

