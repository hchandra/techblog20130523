require 'spec_helper'

describe user('developer') do
  it { should exist }
end

describe group('develop') do
  it { should exist }
end
