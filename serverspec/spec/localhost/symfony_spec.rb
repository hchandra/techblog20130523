require 'spec_helper'

describe file('/home/nginx/symfony') do
  it { should be_directory }
  it { should be_mode 775 }
  it { should be_owned_by 'developer' }
  it { should be_grouped_into 'develop' }
end

describe command('php /home/nginx/symfony/app/console --version') do
  it { should return_stdout 'Symfony version 2.2.1 - app/dev/debug' }
end


pkgs = ['php', 'php-cli', 'php-common', 'php-xml',
        'php-pdo', 'php-devel', 'php-gd', 'php-mbstring',
        'php-mysql', 'php-pdo', 'php-pear', 'php-intl',
        'php-pecl-apc', 'php-process', 'pcre-devel']

pkgs.each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file('/etc/php.ini') do
  it { should be_file }
  it { should contain "date.timezone = Asia/Tokyo" }
end
