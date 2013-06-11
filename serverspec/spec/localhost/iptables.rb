require 'spec_helper'

# ftp
describe port(21) do
  it { should_not be_listening }
end

# ssh
describe port(22) do
  it { should be_listening }
end

# telnet 
describe port(23) do
  it { should_not be_listening }
end

# smtp
describe port(25) do
  it { should_not be_listening }
end

# http
describe port(80) do
  it { should be_listening }
end

# POP
describe port(110) do
  it { should_not be_listening }
end
