##############
# ssh
##############
default['openssh']['package_name'] = case node['platform_family']
                                     when "rhel", "fedora"
                                       %w{openssh-clients openssh}
                                     when "arch","suse"
                                       %w{openssh}
                                     else
                                       %w{openssh-client openssh-server}
                                     end

default['openssh']['service_name'] = case node['platform_family']
                                     when "rhel", "fedora","suse"
                                       "sshd"
                                     else
                                       "ssh"
                                     end

# ssh config group(default)
default['openssh']['client']['host'] = "*"
default['openssh']['server']['authorized_keys_file'] = "%h/.ssh/authorized_keys"
default['openssh']['server']['challenge_response_authentication'] = "no"
default['openssh']['server']['use_p_a_m'] = "yes"

# 以下の項目をカスタマイズ
default['openssh']['server']['permit_root_login'] = "no"
default['openssh']['server']['permit_empty_passwords'] = "no"
default['openssh']['server']['password_authentication'] = "yes"

###############
# ntp
###############
default['ntp']['servers']   = %w{ ntp.nict.jp ntp1.jst.mfeed.ad.jp ntp2.jst.mfeed.ad.jp }
default['ntp']['peers'] = Array.new
default['ntp']['restrictions'] = Array.new

default['ntp']['packages'] = %w{ ntp ntpdate }
default['ntp']['service'] = "ntp"
default['ntp']['varlibdir'] = "/var/lib/ntp"
default['ntp']['driftfile'] = "#{node['ntp']['varlibdir']}/ntp.drift"
default['ntp']['statsdir'] = "/var/log/ntpstats/"
default['ntp']['conf_owner'] = "root"
default['ntp']['conf_group'] = "root"
default['ntp']['var_owner'] = "ntp"
default['ntp']['var_group'] = "ntp"
default['ntp']['leapfile'] = "/etc/ntp.leapseconds"

# overrides on a platform-by-platform basis
case platform
when "redhat","centos","fedora","scientific","amazon","oracle"
  default['ntp']['service'] = "ntpd"
  default['ntp']['packages'] = %w{ ntp }
  if node['platform_version'].to_i >= 6
    default['ntp']['packages'] = %w{ ntp ntpdate } 
  end
when "freebsd"
  default['ntp']['service'] = "ntpd"
  default['ntp']['varlibdir'] = "/var/db"
  default['ntp']['driftfile'] = "#{node['ntp']['varlibdir']}/ntpd.drift"
  default['ntp']['statsdir'] = "#{node['ntp']['varlibdir']}/ntpstats"
  default['ntp']['packages'] = %w{ ntp }
  default['ntp']['conf_group'] = "wheel"
  default['ntp']['var_group'] = "wheel" 
end
