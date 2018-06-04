require 'chefspec'
require 'chefspec/berkshelf'

describe package('ubuntu-fan') do
  it { should be_installed }
end

describe interface('fan-250') do
  it { should be_up } 
end

describe package('lxd-client') do
  it { should be_installed }
end

describe file('/etc/default/lxd_profile') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0755' }
  its('content') { should match(%r{parent: fan-250})}
end

describe command('sudo lxc profile list ') do
  its('exit_status') { should eq 0}
  its('stdout') { should match(%r{default})}
end


describe command('sudo lxc profile show default ') do
  its('exit_status') { should eq 0}
  its('stdout') { should match(%r{parent: fan-250})}
end
