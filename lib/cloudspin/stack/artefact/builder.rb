require 'fileutils'

module Cloudspin
  module Stack
    module Artefact

      class Builder

        include FileUtils

        attr_reader :stack_definition
        attr_reader :stack_definition_name
        attr_reader :stack_definition_version
        attr_reader :dist_folder

        def initialize(stack_definition:,
                       dist_folder:)
          @stack_definition = stack_definition
          @dist_folder = dist_folder
          @stack_definition_name = stack_definition.name
          @stack_definition_version = stack_definition.version
        end

        def build
          puts "Copying files to include in the artefact from #{stack_definition.terraform_source_path} to #{artefact_contents_folder}/src."
          rm_rf(artefact_contents_folder)
          mkpath File.dirname(artefact_contents_folder + '/src')
          cp_r(stack_definition.terraform_source_path, artefact_contents_folder + '/src')
        end

        def package(version)
          puts "Assemble the files from #{artefact_contents_folder} into an artefact in #{dist_folder}"
        end

        def artefact_name
          stack_definition_name + '-' + stack_definition_version
        end

        def artefact_contents_folder
          dist_folder + '/' + artefact_name
        end

      end

    end
  end
end
