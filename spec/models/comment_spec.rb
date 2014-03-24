require 'spec_helper'

describe Comment do
  it { should belong_to(:user) }
  it { should belong_to(:report) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:report) }
  it { should validate_presence_of(:text) }


  describe "updated?" do
    let!(:comment) {FactoryGirl.create(:comment)}
    context "with changed comment" do
      before { comment.update(text: "Some text")}
      it "return true" do
        expect(comment.updated?).to eq true
      end
    end

    context "with unchanged comment" do
      it "return false" do
        expect(comment.updated?).to eq false
      end
    end 
  end
end
