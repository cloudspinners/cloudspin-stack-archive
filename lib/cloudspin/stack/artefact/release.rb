
# Based heavily on bundler source code

module Cloudspin
  module Stack
    module Artefact

      class Release

        attr_reader :version

        def initialize(version)
          @version = version
        end

        def tag_version
          cmd_sh %W[git tag -m Version\ #{version} #{version_tag}]
          puts "Tagged #{version_tag}."
          yield if block_given?
        rescue RuntimeError
          puts "Untagging #{version_tag} due to error."
          sh_with_status %W[git tag -d #{version_tag}]
          raise
        end

        def version_tag
          "v#{version}"
        end

        def chdir(dir, &blk)
          Dir.chdir dir, &blk
        end

        def base
          '.'
        end

        def cmd_sh(cmd, &block)
          out, status = sh_with_status(cmd, &block)
          unless status.success?
            cmd = cmd.shelljoin if cmd.respond_to?(:shelljoin)
            raise(out.empty? ? "Running `#{cmd}` failed. Run this command directly for more detailed output." : out)
          end
          out
        end

        def sh_with_status(cmd, &block)
          puts "cd #{base} && #{cmd}"
          chdir(base) do
            outbuf = IO.popen(cmd, :err => [:child, :out], &:read)
            status = $?
            block.call(outbuf) if status.success? && block
            return [outbuf, status]
          end
        end

        def git_push(remote = "")
          perform_git_push remote
          perform_git_push "#{remote} --tags"
          puts "Pushed git commits and tags."
        end

        def perform_git_push(options = "")
          cmd = "git push #{options}"
          out, status = sh_with_status(cmd)
          return if status.success?
          cmd = cmd.shelljoin if cmd.respond_to?(:shelljoin)
          raise "Couldn't git push. `#{cmd}' failed with the following output:\n\n#{out}\n"
        end

        def already_tagged?
          return false unless cmd_sh(%w[git tag]).split(/\n/).include?(version_tag)
          puts "Tag #{version_tag} has already been created."
          true
        end

      end
    end
  end
end

