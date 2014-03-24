require 'spec_helper'

describe ApplicationHelper do
 
   describe "comments_form_url" do
    let(:report){ FactoryGirl.create(:report) }
    context "New record" do
      let(:comment) {FactoryGirl.build(:comment, id: 1)}
      its "resturn url for new record" do
        helper.comments_form_url(report, comment).should eq "/reports/#{report.id}/comments"
      end
    end
    context "Old record" do
      let(:comment) {FactoryGirl.create(:comment)}
      its "resturn url for old record" do
        helper.comments_form_url(report, comment).should eq "/reports/#{report.id}/comments/#{comment.id}"
      end
    end
  end

  describe "comments_form_class" do
    context "New record" do
      let(:comment) {FactoryGirl.build(:report, id: 1)}
      its "resturn class for new record" do
        helper.comments_form_class(comment).should eq ""
      end
    end
    context "Old record" do
      let(:comment) {FactoryGirl.create(:report)}
      its "resturn class for old record" do
        helper.comments_form_class(comment).should eq "well"
      end
    end
  end
end