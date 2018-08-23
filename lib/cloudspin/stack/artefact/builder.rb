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
        attr_reader :folders_to_package

        def initialize(stack_definition:,
                       dist_folder:)
          @stack_definition = stack_definition
          @dist_folder = dist_folder
          @stack_definition_name = stack_definition.name
          @stack_definition_version = stack_definition.version
          @folders_to_package = {
            stack_definition.terraform_source_path => 'src'
          }
        end

        def build
          puts "Copying files to include in the artefact to #{artefact_contents_folder}/src."
          rm_rf(artefact_contents_folder)
          folders_to_package.each { |source, destination|
            puts "Copying #{source} to #{artefact_contents_folder + '/' + destination}"
            mkpath File.dirname(artefact_contents_folder + '/' + destination)
            cp_r(source, artefact_contents_folder + '/' + destination)
          }

        end

        def add_folder_to_package(source_folder, artefact_subfolder:)
          @folders_to_package[source_folder] = artefact_subfolder
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
