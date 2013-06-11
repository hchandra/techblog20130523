require 'spec_helper'

describe service('ntpd') do
  it { should be_enabled   }
  it { should be_running   }
end


describe file('/etc/ntp.conf') do
  it { should be_file }
  it { should contain "server ntp.nict.jp" }
  it { should contain "server ntp1.jst.mfeed.ad.jp" }
  it { should contain "server ntp2.jst.mfeed.ad.jp" }
end

