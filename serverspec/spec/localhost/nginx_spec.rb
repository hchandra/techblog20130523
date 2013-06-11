require 'spec_helper'

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled   }
  it { should be_running   }
end

describe package('php-fpm') do
  it { should be_installed }
end

describe service('php-fpm') do
  it { should be_enabled   }
  it { should be_running   }
end

describe file('/etc/nginx/conf.d/default.conf') do
  it { should be_file }
  it { should contain "server_name  localhost" }
end

describe file('/etc/nginx/nginx.conf') do
  it { should be_file }
  it { should contain "user              nginx develop;" }
end

describe file('/etc/php-fpm.d/www.conf') do
  it { should be_file }
  it { should contain "user = nginx" }
  it { should contain "group = develop" }
end

