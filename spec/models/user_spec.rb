require 'spec_helper'

describe User do

  it { should have_many(:reports).dependent(:destroy) }
  it { should have_many(:notifications).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should have_many(:edited_reports) }
  it { should have_many(:sent_notifications) }
  it { should belong_to(:editor)}
end