require 'spec_helper'
require 'action_view/helpers/sanitize_helper'

class SanitizeHelper
  include ActionView::Helpers::SanitizeHelper
end

describe 'Report' do
  let(:report) { FactoryGirl.create(:report) }
 
  context '#index' do
    before { @report = report }

    context 'user not logged' do
      before { visit reports_path }

      it 'contain report title' do
        within("div.reports") do
           expect(page).to have_content report.title
        end
      end

      it 'contain first 200 letters of report text' do
        within("div.reports") do
          expect(page).to have_content SanitizeHelper.new.strip_tags(report.description).truncate(200, separator: ' ')
        end
      end

      it 'contain title links to report#show' do
        within("div.reports") do
          expect(page).to have_link report.title, report_path(report)
        end
      end

      it 'not contain delete link' do
        within("div.reports") do
          expect(page).not_to have_link "delete", report_path(report)
        end
      end

      it 'not contain edit link' do
        within("div.reports") do
          expect(page).not_to have_link "edit", edit_report_path(report)
        end
      end
    end

    context 'editor logged' do
      let(:user) { FactoryGirl.create(:user) }

      before :each do
        login_as(user, :scope => :user)
        visit reports_path
      end

      after(:each) { Warden.test_reset!  }

      it 'contain delete link' do
        within("div.reports .controls") do
          expect(page).to have_link "delete", report_path(report)
        end
      end

      it 'contain edit link' do
        within("div.reports .controls") do
          expect(page).to have_link "edit", edit_report_path(report)
        end
      end

    end
  end

  context '#new' do

    context 'user logged' do
      let(:user) { FactoryGirl.create(:user) }
      let!(:category) { FactoryGirl.create(:category) }

      before :each do
        login_as(user, :scope => :user)
        visit new_report_path
      end

      after(:each) { Warden.test_reset!  }

      it 'can create report' do
        expect do 
          within('form.new_report') do
            fill_in 'report_title', with: "Some title"
            fill_in 'report_description', with: "Some description"
            choose(category.name)
            click_on 'Create Report'
          end
        end.to change { Report.count }.by(1)
      end
    end

    context 'user not logged' do
      before { visit new_report_path }

      it 'gets redirected' do
        expect(page.current_path).to eq new_user_session_path
      end
    end
  end

  context "#show" do

    context 'editor logged' do
      let(:user) { FactoryGirl.create(:user) }

      before :each do
        login_as(user, :scope => :user)
        visit report_path(report)
      end

      after(:each) { Warden.test_reset!  }

      it 'contain delete link' do
        within('.report .controls') do
          expect(page).to have_link 'delete', report_path(report)
        end
      end

      it 'contain edit link' do
        within('.report .controls') do
          expect(page).to have_link 'edit', edit_report_path(report)
        end
      end
    end

    context 'user not logged' do
      before { visit report_path(report)}

      it 'contain report title' do
        within('.report') do
          expect(page).to have_content report.title
        end
      end

      it 'contain report text' do
        within('.report') do
          expect(page).to have_content SanitizeHelper.new.strip_tags(report.description)
        end
      end

      it 'contain creator name' do
        within('.report') do
          expect(page).to have_content report.user.name
        end
      end

      it 'contain created_at date' do
        within('.report') do
          expect(page).to have_content time_ago_in_words(report.created_at)
        end
      end

      it 'not contain delete link' do
        within('.report') do
          expect(page).not_to have_link 'delete', report_path(report)
        end
      end

      it 'not contain edit link' do
        within('.report') do
          expect(page).not_to have_link 'edit', edit_report_path(report)
        end
      end
    end
  end

  context "#destroy" do
    let!(:report) { FactoryGirl.create(:report) }
    
    context "user is logged" do
      let(:user) { FactoryGirl.create(:user) }

      before :each do
        login_as(user, :scope => :user)
      end

      after(:each) { Warden.test_reset!  }



      context "in show page" do
        before {visit report_path(report)}

        it 'can destroy report' do
          expect do
            within('.report .controls') do
              click_on 'delete'
            end
          end.to change { Report.count }.by(-1)
        end
      end

      context "in index page" do
        before { visit reports_path }

        it 'can destroy report' do
          expect do
            within('div.reports') do
              click_on 'delete'
            end
          end.to change { Report.count }.by(-1)
        end
      end
    end
  end

  context "#edit" do

    context "logged" do
      let(:user) { FactoryGirl.create(:user) }
      let(:report) { FactoryGirl.create(:report) }
      

      before :each do
        login_as(user, :scope => :user)

        visit edit_report_path(report)
        within("form.edit_report") do
          fill_in 'report_title', with: "New Title"
          fill_in 'report_description', with: 'New Body text'
          click_on 'Update Report'
        end
      end

      after(:each) { Warden.test_reset! }

      it 'title is changed' do
        expect(page).to have_content "New Title"
      end

      it 'text is changed' do
        expect(page).to have_content "New Body text"
      end
    end

    context 'not logged' do
      it 'gets redirected' do
        visit edit_report_path(report)
        expect(page.current_path).to eq new_user_session_path
      end
    end
  end
end