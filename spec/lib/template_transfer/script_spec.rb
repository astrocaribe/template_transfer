require 'spec_helper'

describe TemplateTransfer::Script do
  let(:args) {[]}

  subject { TemplateTransfer::Script.new( args ) }

  # Suppress script output
  before(:each) do
    $stdout.stubs(:puts)
    # allow_any_instance_of(IO).to receive(:puts)
  end

  describe 'attributes' do
    describe ':config' do
      it { should respond_to(:config)       }
      it { should_not respond_to(:config=)  }
    end

    describe ':template_array' do
      it { should respond_to(:template_array)       }
      it { should_not respond_to(:template_array=)  }
    end
  end

  describe '#initialize' do
  end

  describe '#run' do
    it 'retrieves all template info'
    it 'retrieves a single template'
    it 'creates a backup of template'
    it 'creates a new template'
    it 'populates new template'
  end

  describe '#retreive_all_template_info' do
    it 'successfully returns template array'

    context 'when a template array returned' do
      it 'is of type array'
      it 'contains :id key pair'
      it 'contains :name key pair'
    end
  end

  describe '#retrieve_single_template' do
    describe 'arity' do
      it 'raises ArgumentError when called with no arguments' do
        expect do
          subject.retrieve_single_template
        end.to raise_error(ArgumentError)
      end

      it 'does not raise error when called with required arguments'
    end

    it 'successfully returns single template'

    context 'when a signle template returned' do
      it 'is of type JSON'
      it 'contains :id key pair'
      it 'contains :name key pair'
      it 'contains :versions key pair'
    end
  end

  describe '#backup_template' do
    describe 'arity' do
      it 'raises ArgumentError when called with no arguments'
      it 'does not raise error when called with required argument'
    end

    it 'backs up template'
  end

  describe '#create_template' do
    describe 'arity' do
      it 'raises ArgumentError when called with no arguments'
      it 'does not raise error when called with require argument'
    end

    it 'successfully creates a template'

    context 'when new template created' do
      it 'returns a template id'
      it 'new template id does not match old template id'
    end
  end

  describe '#populate_template' do
    describe 'arity' do
      it 'raises ArgumentError when called with no arguments'
      it 'raises ArgumentError when called with one argument'
      it 'does not raise error when called with required arguments'
    end

    # More tests needed here to account for
    # - versions
    # - request structure
    # - response structure
  end

end