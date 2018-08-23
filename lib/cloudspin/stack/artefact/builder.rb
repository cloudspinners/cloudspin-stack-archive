
module Cloudspin
  module Stack
    module Artefact

      class Builder

        def initialize(stack_definition:,
                       working_folder:
                      )
          @stack_definition = stack_definition
          @working_folder = working_folder
        end

        def build(version)
          puts "Build an artefact now. kthxbye"
        end

      end

    end
  end
end
