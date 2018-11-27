require 'spec_helper'

describe 'azurelaagent::install_linux' do

  let(:params) do
    {
      'ensure' => 'present',
    }
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
