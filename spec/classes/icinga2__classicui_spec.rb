require 'spec_helper'
describe 'icinga2::classicui' do
  describe 'on Debian-based systems' do
    let (:facts) { {
      :osfamily       => 'Debian',
      :lsbdistid      => 'Debian',
      :concat_basedir => '/foo',
    } }
    it {
      should contain_class('icinga2::classicui')
      should contain_class('icinga2::classicui::package')
      should contain_class('icinga2::classicui::config')
      should contain_package('icinga2-classicui')
    }
    context 'with all defaults' do
      it {
        should contain_file('/etc/icinga2/classicui/htpasswd.users').with_content(/icingaadmin/)
      }
    end
    context 'frontend_users => { root => foo, adm => bar }' do
      let (:params) { { :frontend_users => { 'root' => 'foo', 'adm' => 'bar' } } }
      it {
        should contain_file('/etc/icinga2/classicui/htpasswd.users').with_content(/root:foo/).with_content(/adm:bar/)
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
