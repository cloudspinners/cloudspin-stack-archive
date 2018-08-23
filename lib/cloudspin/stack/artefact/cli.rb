
require 'thor'

module Cloudspin
  module Artefact

    class CLI < Thor

      class_option :terraform_source,
        :aliases => '-t',
        :banner => 'PATH',
        :default => './src',
        :desc => 'Terraform project source files will be copied from this folder'

      class_option :build_folder,
        :aliases => '-w',
        :banner => 'PATH',
        :default => './build',
        :desc => 'Files to be included in the artefact will be copied to this folder'

      class_option :dist_folder,
        :aliases => '-w',
        :banner => 'PATH',
        :default => './build',
        :desc => 'The artefact will be created in this folder'

      desc 'build', 'Prepare files to be packaged'
      def build
        puts 'build'
      end

      desc 'package', 'Package the files'
      def package
        puts 'package'
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
