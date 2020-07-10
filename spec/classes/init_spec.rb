require 'spec_helper'
describe 'vmware_horizon_view' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('vmware_horizon_view') }
  end
end
