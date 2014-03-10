require 'spec_helper'

describe User do

  it { should have_many(:reports).dependent(:destroy) }
  it { should have_many(:notifications).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:role) }
  it {should ensure_inclusion_of(:role).in_array(%w(editor author)) }
end