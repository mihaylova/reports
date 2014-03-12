require 'spec_helper'

describe AdminUser do
  it { should have_many(:notifications) }
  it { should have_many(:reports) }

end
