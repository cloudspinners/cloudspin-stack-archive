RSpec.describe Cloudspin::Stack::Artefact::Builder do

  let(:stack_definition) {
    Cloudspin::Stack::Definition.new(
      terraform_source_path: 'some/path',
      parameter_names: [ 'a', 'b'],
      resource_names: [ 'x', 'y' ],
      stack: { :name => 'example_stack', :version => '1.1.1' }
    )
  }


  let(:builder) {  
    Cloudspin::Stack::Artefact::Builder.new(stack_definition: stack_definition, dist_folder: './dist')
  }

  it 'builds the expected artefact name' do
    expect(builder.artefact_name).to eq('example_stack-1.1.1')
  end

end
