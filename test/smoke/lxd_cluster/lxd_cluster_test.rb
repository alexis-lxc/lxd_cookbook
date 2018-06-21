require 'chefspec'
require 'chefspec/berkshelf'

describe interface('fan10') do
  it { should be_up } 
end

describe command('sudo lxc profile list ') do
  its('exit_status') { should eq 0}
  its('stdout') { should match(%r{default})}
end

describe command('sudo lxc profile show default ') do
  its('exit_status') { should eq 0}
  its('stdout') { should match(%r{parent: fan10})}
end

describe command('sudo lxc cluster list') do
  its('exit_status') { should eq 0}
  its('stdout') { should match(%r{lxd-cluster})}
end
