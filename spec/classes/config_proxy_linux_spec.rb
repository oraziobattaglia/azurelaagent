require 'spec_helper'

describe 'azurelaagent::config_proxy_linux' do

  let(:params) do
    {
      'proxy_server' => 'http://yourproxy.com',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
