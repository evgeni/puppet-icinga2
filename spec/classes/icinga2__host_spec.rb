require 'spec_helper'
describe 'icinga2::host' do
  describe 'on Debian-based systems' do
    let (:facts) { {
      :osfamily => 'Debian',
      :virtual => 'physical',
      :is_virtual => false,
    } }
    it {
      should contain_class('icinga2::host')
      should contain_file('/etc/nagios/nrpe.d/disk.cfg')
      should contain_file('/etc/nagios/nrpe.d/smart.cfg')
      should contain_file('/etc/nagios/nrpe.d/check_ntp_peer.cfg')
      should contain_file('/etc/nagios-plugins/obsolete-packages-ignore.d/puppet-icinga2-ignores')
    }
  end
end


