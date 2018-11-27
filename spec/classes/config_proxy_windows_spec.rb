require 'spec_helper'

describe 'azurelaagent::config_proxy_windows' do

  let(:params) do
    {
      'proxy_server' => 'http://yourproxy.com',
    }
  end

  test_on = {
    :hardwaremodels => ['x86_64', 'i386'],
    :supported_os   => [
      {
        'operatingsystem'        => 'windows',
        'operatingsystemrelease' => ['2008 R2','2012 R2','10'],
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
