
require 'thor'

module Cloudspin
  module Artefact

    class CLI < Thor

      class_option :dist_folder,
        :aliases => '-d',
        :banner => 'PATH',
        :default => './dist',
        :desc => 'The artefact will be created in this folder'

      class_option :source,
        :aliases => '-s',
        :banner => 'PATH',
        :default => './src',
        :desc => 'Folder with the terraform project source files'

      desc 'build', 'Assemble the files to be packaged'
      option :test_folder,
          :aliases => '-t',
          :banner => 'PATH',
          :default => './test'
      option :environments_folder,
          :aliases => '-e',
          :banner => 'PATH',
          :default => './environments'
      option :instance_defaults_file,
          :aliases => '-f',
          :banner => 'FILENAME',
          :default => './stack-instance-defaults.yaml'
      def build
        add_folder(options[:test_folder])
        add_folder(options[:environments_folder])
        add_file(options[:instance_defaults_file])
        builder.build
      end

      desc 'package', 'Package the files'
      def package
        builder.package
      end

      desc 'publish', 'Upload the package'
      def publish
        puts 'publish'
      end

      desc 'get', 'Download a package'
      def get
        put 'get'
      end


      no_commands do
        def builder
          @builder ||= Cloudspin::Stack::Artefact::Builder.new(
            stack_definition: stack_definition,
            dist_folder: options[:dist_folder]
          )
        end

        def add_folder(folder = nil)
          builder.add_folder_to_package(folder) if Dir.exists?(folder)
        end

        def add_file(filename = nil)
          builder.add_file_to_package(filename) if File.exists?(filename)
        end

        def stack_definition
          Cloudspin::Stack::Definition.from_file(stack_definition_file)
        end

        def stack_definition_file
          raise NoStackDefinitionFolder unless Dir.exists? options[:source]
          raise NoStackDefinitionConfigurationFile unless File.exists? "#{options[:source]}/stack-definition.yaml"
          "#{options[:source]}/stack-definition.yaml"
        end
      end

      def self.exit_on_failure?
        true
      end

    end

    class NoStackDefinitionFolder < StandardError; end
    class NoStackDefinitionConfigurationFile < StandardError; end

  end

end
