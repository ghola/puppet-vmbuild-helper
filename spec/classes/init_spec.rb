require 'spec_helper'
describe 'vmbuildhelper' do

  context 'with defaults for all parameters' do
    it { should contain_class('vmbuildhelper') }
  end
end
