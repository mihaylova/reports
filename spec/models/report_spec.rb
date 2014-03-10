require 'spec_helper'

describe Report do
  it { should belong_to(:user) }
  it { should have_one(:permissions).dependent(:destroy) }
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:category) }
end