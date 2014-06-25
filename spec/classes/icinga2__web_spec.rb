require 'spec_helper'
describe 'icinga2::web' do
  describe 'on Debian-based systems' do
    let (:facts) { {
      :osfamily       => 'Debian',
      :lsbdistid      => 'Debian',
      :concat_basedir => '/foo',
    } }
    it {
      should contain_class('icinga2::web')
      should contain_class('icinga2::web::package')
      #should contain_class('icinga2::web::config')
      should contain_package('icinga-web')
    }
  end
  describe 'on other systems' do
    it {
      expect {
        should compile
      }.to raise_error(Puppet::Error, /This module only supports Debian-based systems/)
    }
  end
end
