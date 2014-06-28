require 'spec_helper'
describe 'icinga2::nrpe' do
  describe 'on Debian-based systems' do
    let (:facts) { {
      :osfamily => 'Debian',
    } }
    it {
      should contain_class('icinga2::nrpe')
      should contain_class('icinga2::nrpe::package')
      should contain_class('icinga2::nrpe::config')
      should contain_class('icinga2::nrpe::service')
      should contain_package('nagios-nrpe-server')
      should contain_service('nagios-nrpe-server')
    }
  end
end

