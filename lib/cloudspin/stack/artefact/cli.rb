
require 'thor'

module Cloudspin
  module Artefact

    class CLI < Thor

      class_option :terraform_source,
        :aliases => '-t',
        :banner => 'PATH',
        :default => './src',
        :desc => 'Terraform project source files will be copied from this folder'

      class_option :dist_folder,
        :aliases => '-d',
        :banner => 'PATH',
        :default => './dist',
        :desc => 'The artefact will be created in this folder'

      desc 'build', 'Assemble the files to be packaged'
      def build
        builder.build
      end

      desc 'dist', 'Package the files'
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
          Cloudspin::Stack::Artefact::Builder.new(stack_definition: stack_definition,
                                                  dist_folder: options[:dist_folder])
        end

        def stack_definition
          Cloudspin::Stack::Definition.from_file(options[:terraform_source] + '/stack.yaml')
        end
      end

      def self.exit_on_failure?
        true
      end

    end

  end

end
