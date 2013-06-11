require 'spec_helper'

describe service('sshd') do
  it { should be_enabled   }
  it { should be_running   }
end


describe file('/etc/ssh/sshd_config') do
  it { should be_file }
  it { should contain "PasswordAuthentication yes" }
  it { should contain "PermitEmptyPasswords no" }
  it { should contain "PermitRootLogin no" }
end

