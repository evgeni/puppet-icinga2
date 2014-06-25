require 'spec_helper'
describe 'icinga2::ido' do
  describe 'on Debian-based systems' do
    let (:facts) { {
      :osfamily       => 'Debian',
      :lsbdistid      => 'Debian',
      :concat_basedir => '/foo',
    } }
    it {
      should contain_class('icinga2::ido')
      should contain_class('icinga2::ido::package')
      should contain_class('icinga2::ido::config')
    }
    context 'with all defaults' do
      it {
        should contain_package('icinga2-ido-pgsql')
	should contain_icinga2__feature('ido-pgsql')
	should contain_file('/etc/icinga2/features-enabled/ido-pgsql.conf').with_ensure('link')
      }
    end
    context 'backend => mysql' do
      let (:params) { { :backend => 'mysql' } }
      it {
        should contain_package('icinga2-ido-mysql')
	should contain_icinga2__feature('ido-mysql')
	should contain_file('/etc/icinga2/features-enabled/ido-mysql.conf').with_ensure('link')
      }
    end
    context 'backend => pgsql' do
      let (:params) { { :backend => 'pgsql' } }
      it {
        should contain_package('icinga2-ido-pgsql')
	should contain_icinga2__feature('ido-pgsql')
	should contain_file('/etc/icinga2/features-enabled/ido-pgsql.conf').with_ensure('link')
      }
    end
  end
  describe 'on other systems' do
    it {
      expect {
        should compile
      }.to raise_error(Puppet::Error, /This module only supports Debian-based systems/)
    }
  end
end
