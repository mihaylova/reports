require 'spec_helper'

describe 'Comments' do
  let(:user) { FactoryGirl.create(:user, editor: false) }
  let(:comment) {FactoryGirl.create(:comment)}

  context "logged user" do
    before :each do
      login_as(user, :scope => :user)
      visit report_path(comment.report)
    end

    after(:each) { Warden.test_reset!  }

    it "contain create comment form" do
      within (".comment-form") do
        expect(page).to have_selector ("#comment_text")
      end
    end

    context "comment author" do
      before do
        comment.update(user: user)
        visit report_path(comment.report)
      end

      it "can delete it's own comments" do
        within ("#comments .comment") do
          expect(page).to have_link 'delete', report_comment_path(comment.report, comment)
        end
      end

      it "can edit it's own comments" do
        within ("#comments .comment") do
          expect(page).to have_link 'edit', edit_report_comment_path(comment.report, comment)
        end
      end
    end

    context "not comment author" do
      before do
        comment.update(user: FactoryGirl.create(:user))
        visit report_path(comment.report)
      end

      it "can't delete other user's comments" do
        within ("#comments .comment") do
          expect(page).not_to have_link 'delete', report_comment_path(comment.report, comment)
        end
      end


      it "can't edit other user's comments" do
        within ("#comments .comment") do
          expect(page).not_to have_link 'edit', edit_report_comment_path(comment.report, comment)
        end
      end
    end
  end

  context "report author" do
    let(:user) { FactoryGirl.create(:user, editor: false) }
    let(:report) { FactoryGirl.create(:report, user: user) }
    let(:comment) { FactoryGirl.create(:comment, text: "Some text", user: FactoryGirl.create(:user), report: report)}

    before do
      login_as(user, :scope => :user)
      visit report_path(comment.report)
    end

    it "can't delete comments on your report" do
      within ("#comments .comment") do
        expect(page).to have_link 'delete', report_comment_path(comment.report, comment)
      end
    end


    it "can't edit comments on your report" do
      within ("#comments .comment") do
        expect(page).not_to have_link 'edit', edit_report_comment_path(comment.report, comment)
      end
    end
  end

  context "not logged user" do
    before {visit report_path(comment.report)}

    it "not contain create comment form" do
      expect(page).not_to have_selector(".comment-form")
    end

    it "can't delete comments" do
      within ("#comments .comment") do
        expect(page).not_to have_link 'delete', report_comment_path(comment.report, comment)
      end
    end


    it "can't edit  comments" do
      within ("#comments .comment") do
        expect(page).not_to have_link 'edit', edit_report_comment_path(comment.report, comment)
      end
    end

    it "contain report's comments" do
      expect(page).to have_content comment.text
    end

    it "contain report's comments authors" do
      expect(page).to have_content comment.user.name
    end

    it "contain report's comments created at date" do
      expect(page).to have_content time_ago_in_words(comment.created_at)
    end
  end
end