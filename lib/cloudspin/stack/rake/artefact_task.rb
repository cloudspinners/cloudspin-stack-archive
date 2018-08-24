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
          task :build do |t, args|
            builder.build
          end

          desc 'Package the artefact'
          task :package do |t, args|
            builder.package
          end
        end

        def builder
          Cloudspin::Stack::Artefact::Builder.new(stack_definition: stack_definition,
                                                  dist_folder: @dist_folder)
        end

        def stack_definition
          Cloudspin::Stack::Definition.from_file(@definition_folder + '/stack.yaml')
        end

      end
    end
  end
end

