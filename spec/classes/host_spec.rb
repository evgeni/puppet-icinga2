require 'spec_helper'
describe 'icinga2::host' do
  describe 'on Debian-based systems' do
    let (:facts) { {
      :osfamily => 'Debian',
    } }
    it {
      should contain_class('icinga2::host')
    }
  end
end


