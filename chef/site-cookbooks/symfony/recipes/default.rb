#
# Cookbook Name:: symfony
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# iptable open 22,80 port
simple_iptables_rule "ssh" do
  rule "--proto tcp --dport 22"
  jump "ACCEPT"
end

simple_iptables_rule "http" do
  rule [ "--proto tcp --dport 80",
         "--proto tcp --dport 443" ]
  jump "ACCEPT"
end

# user and group create
group 'develop' do
   group_name 'develop'
   gid 1000
   action [:create]
end

user 'developer' do
    comment 'developer'
    uid 1000
    group 'develop'
    home  '/home/developer'
    shell '/bin/bash'
    password nil
    supports :manage_home => true
    action [:create , :manage]
end

directory '/home/nginx/' do
    owner 'developer'
    group 'develop'
    mode  '0775'
    action :create
end

# require php package install
pkgs = ['php', 'php-cli', 'php-common', 'php-xml',
        'php-pdo', 'php-devel', 'php-gd', 'php-mbstring',
        'php-mysql', 'php-pdo', 'php-pear', 'php-intl',
        'php-pecl-apc', 'php-process', 'pcre-devel']

pkgs.each do |pkg|
  package pkg do
    action :install
  end
  sleep 2
end

# php-fpm install
package "php-fpm" do
    action :install
end

# nginx install
package "nginx" do
    action :install
end

# composer install
execute "composer install" do
  command "curl -s http://getcomposer.org/installer | php && mv composer.phar /home/nginx/"
  creates "/home/nginx/composer.phar"
  action :run
end

execute "composer update" do
  command "php /home/nginx/composer.phar self-update"
  action :run
end

# symfony install
execute "symfony install" do
  command "rm -rf /home/nginx/symfony && php /home/nginx/composer.phar create-project symfony/framework-standard-edition /home/nginx/symfony 2.2.2"
  creates "/home/nginx/symfony/app/bootstrap.php.cache"
  action :run
end

template "app_dev.php" do
    path "/home/nginx/symfony/web/app_dev.php"
    source "app_dev.php.erb"
    owner "developer"
    group "develop"
    mode 0775
end

execute "symfony dir chown" do
  command "chown -R developer:develop /home/nginx/symfony"
  action :run
end

execute "symfony dir chmod" do
  command "chmod -R 775 /home/nginx/symfony"
  action :run
end


template "php.ini" do
    path "/etc/php.ini"
    source "php.ini.erb"
    owner "root"
    group "root"
    mode 0644
end

# php-fpm configure
template "www.conf" do
    path "/etc/php-fpm.d/www.conf"
    source "www.conf.erb"
    owner "root"
    group "root"
    mode 0644
end

service "php-fpm" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable , :start ]
    subscribes :reload, resources("template[php.ini]","template[www.conf]"), :immediately
end

# nginx configure
template "default.conf" do
    path "/etc/nginx/conf.d/default.conf"
    source "default.conf.erb"
    owner "root"
    group "root"
    mode 0644
end

template "nginx.conf" do
    path "/etc/nginx/nginx.conf"
    source "nginx.conf.erb"
    owner "root"
    group "root"
    mode 0644
end

service "nginx" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable , :start ]
    subscribes :reload, resources("template[nginx.conf]", "template[default.conf]"), :immediately
end


