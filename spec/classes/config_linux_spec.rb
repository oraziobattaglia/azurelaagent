require 'spec_helper'

describe 'azurelaagent::config_linux' do

  let(:params) do
    {
      'azure_id' => 'azure_id',
      'azure_shared' => 'azure_shared',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
