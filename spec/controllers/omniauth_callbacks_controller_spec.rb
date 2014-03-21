require 'spec_helper'

describe Users::OmniauthCallbacksController do
  before { visit root_path }

  it "contain link to login with Facebook account" do
    expect(page).to have_link "Sign in with Facebook", user_omniauth_authorize_path(:facebook)
  end

  context "with correct parameters" do
    before do 
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        :provider => 'facebook', 
        :uid => '123545', 
        :info => {email: "email@example.com", name: "Name"}
      })
    end

    context "After login" do
      before { click_link "Sign in with Facebook" }

      #TODO: test with JS
      xit "show logout link" do
        expect(page).to have_link "Logout", destroy_user_session_path
      end

      xit "show success message" do
        expect(page).to have_content("Successfully authenticated from Facebook account.")
      end

      it "can set user data from Facebook" do
        user = User.last
        expect(user.email).to eq 'email@example.com'
        expect(user.name).to eq 'Name'
        expect(user.provider).to eq 'facebook'
        expect(user.uid).to eq '123545'
      end
    end

    it "can register with Facebook" do
      expect do
        click_link "Sign in with Facebook"
      end.to change { User.count }.by(1)
    end

    context "when have user whit that email in db" do
      before { @user = FactoryGirl.create(:user, email: 'email@example.com') }
      
      it "doesn't create new user" do
        expect do
          click_link "Sign in with Facebook"
        end.to change { User.count }.by(0)
      end

      context "After Sign in whit Facebook" do
        before { click_link "Sign in with Facebook" }

        it "set uid and provider on existing user" do
          @user.reload
          expect(@user.uid).to eq '123545'
          expect(@user.provider).to eq "facebook"
        end

        xit "set set user data from fb if not exist in db" do
          @user.reload
          expect(@user.birthday).to eq Date.new 2000, 01, 01
        end
      end
    end
  end

  context "with incorrect parameters" do 
    before do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials 
      click_link "Sign in with Facebook"
    end

    it 'can handle authentication error' do
      expect(page).to have_content("Could not authenticate you from Facebook")
    end
  end
end