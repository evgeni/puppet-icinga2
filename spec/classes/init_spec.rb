require 'spec_helper'
describe 'icinga2' do
  describe 'on Debian-based systems' do
    let (:facts) { {
      :osfamily       => 'Debian',
      :lsbdistid      => 'Debian',
      :concat_basedir => '/foo',
    } }
    it {
      should contain_class('icinga2')

      should contain_class('icinga2::service')
      should contain_service('icinga2')

      should contain_class('icinga2::package')
      should contain_apt__source('debmon_org')
      should contain_package('icinga2')
      should contain_package('nagios-nrpe-plugin')

      should contain_file('/etc/icinga2/conf.d/puppet/')
    }
    context 'all defaults' do
      it {
        should contain_class('icinga2::classicui')
      }
    end
    context 'frontend => classicui' do
      let (:params) { { :frontend => 'classicui' } }
      it {
        should contain_class('icinga2::classicui')
      }
    end
    context 'frontend => web' do
      let (:params) { { :frontend => 'web' } }
      it {
        should contain_class('icinga2::web')
      }
    end
    context 'frontend => ""' do
      let (:params) { { :frontend => '' } }
      it {
        should_not contain_class('icinga2::classicui')
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
