require 'fileutils'
require 'rubygems'
require 'rubygems/package'
require 'util/tar'

module Cloudspin
  module Stack
    module Artefact

      class Builder

        include Util::Tar
        include FileUtils

        attr_reader :stack_definition
        attr_reader :stack_definition_name
        attr_reader :stack_definition_version
        attr_reader :dist_folder
        attr_reader :folders_to_package
        attr_reader :files_to_package

        def initialize(stack_definition:,
                       dist_folder:)
          @stack_definition = stack_definition
          @dist_folder = dist_folder
          @stack_definition_name = stack_definition.name
          @stack_definition_version = stack_definition.version
          @folders_to_package = {
            stack_definition.source_path => 'src'
          }
          @files_to_package = []
        end

        def build
          puts "Copying files to include in the artefact to #{artefact_contents_folder}/src."
          rm_rf(artefact_contents_folder)
          folders_to_package.each { |source, destination|
            puts "Copying #{source} to #{artefact_contents_folder + '/' + destination}"
            mkpath File.dirname(artefact_contents_folder + '/' + destination)
            cp_r(source, artefact_contents_folder + '/' + destination)
          }
          files_to_package.each { |file|
            puts "Copying #{file} to #{artefact_contents_folder + '/' + file}"
            cp(file, artefact_contents_folder + '/' + file)
          }
        end

        def add_folder_to_package(source_folder, artefact_subfolder: nil)
          artefact_subfolder ||= File.basename(source_folder)
          @folders_to_package[source_folder] = artefact_subfolder
        end

        def add_file_to_package(source_file)
          @files_to_package << source_file
        end

        def package
          puts "Create #{artefact_path} from #{artefact_contents_folder}"
          rm_f(artefact_path)
          tar = tar(artefact_contents_folder)
          tgz = gzip(tar)
          File.write(artefact_path, tgz.read)
        end
        def artefact_name
          stack_definition_name + '-' + stack_definition_version
        end

        def artefact_contents_folder
          dist_folder + '/' + artefact_name
        end

        def artefact_path
          dist_folder + '/' + artefact_name + '.tgz'
        end

        def artefact_files
          file_list = []
          Find.find(artefact_contents_folder) do |file|
            file_list << "#{artefact_contents_folder}/#{file}"
          end
          file_list
        end

      end

    end
  end
end
