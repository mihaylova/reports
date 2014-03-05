require 'spec_helper'

describe Report do
  it { should belong_to(:user) }
  it { should belong_to(:category) }
  it { should validate_presence_of(:text) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:category) }
end