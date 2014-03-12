require 'spec_helper'

describe AdminUser do
  it { should have_many(:sent_notifications) }
  it { should have_many(:edited_reports) }
  it { should have_many(:edited_users) }
  it { should have_many(:destroyed_reports) }
end
