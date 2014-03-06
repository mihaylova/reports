require 'spec_helper'

describe Category do
  it { should have_many(:reports)}
  it { should validate_presence_of(:name) }
end
