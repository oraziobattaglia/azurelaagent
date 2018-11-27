require 'spec_helper'

describe 'azurelaagent::config_linux' do

  let(:params) do
    {
      'azure_id' => 'azure_id',
      'azure_shared' => 'azure_shared',
    }
  end

  test_on = {
    :hardwaremodels => ['x86_64', 'i386'],
    :supported_os   => [
      {
        'operatingsystem'        => 'CentOS',
        'operatingsystemrelease' => ['6'],
      },
      {
        'operatingsystem'        => 'Ubuntu',
        'operatingsystemrelease' => ['14.04','16.04','18.04'],
      },      
    ],
  }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
