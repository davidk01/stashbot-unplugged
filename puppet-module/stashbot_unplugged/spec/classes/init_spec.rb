require 'spec_helper'
describe 'unplugged' do

  context 'with defaults for all parameters' do
    it { should contain_class('unplugged') }
  end
end
