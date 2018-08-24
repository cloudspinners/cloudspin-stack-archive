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

  it 'has only one folder by default' do
    expect(builder.folders_to_package.size).to eq(1)
  end

  it 'includes source folder by default' do
    expect(builder.folders_to_package).to include('some/path' => 'src')
  end

  it 'has two folders after one is added' do
    builder.add_folder_to_package('./tests', artefact_subfolder: 'tests')
    expect(builder.folders_to_package.size).to eq(2)
  end

  it 'includes added source folder' do
    builder.add_folder_to_package('./tests', artefact_subfolder: 'tests')
    expect(builder.folders_to_package).to include('./tests' => 'tests')
  end

  it 'uses source folder name for target folder name by default' do
    builder.add_folder_to_package('./path/xtests')
    expect(builder.folders_to_package).to include('./path/xtests' => 'xtests')
  end

end
