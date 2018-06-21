require 'chefspec'
require 'chefspec/berkshelf'

describe command('sudo lxc profile list ') do
  its('exit_status') { should eq 0}
  its('stdout') { should match(%r{default})}
end

describe command('sudo lxc profile show default ') do
  its('exit_status') { should eq 0}
  its('stdout') { should match(%r{parent: fan10})}
end

describe command("lxd sql global 'select count(*) from nodes;'") do
  its('exit_status') { should eq 0}
  its('stdout') { should match(%r{2})}
end
