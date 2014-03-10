require 'spec_helper'

describe User do

  it { should have_many(:reports) }
  it { should have_many(:notifications) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:role) }
  it {should ensure_inclusion_of(:role).in_array(%w(editor author)) }
end