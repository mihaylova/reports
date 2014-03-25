require 'spec_helper'

describe 'Registrations' do
  context "user is logged" do
    before do
      @user = FactoryGirl.create(:user) 
      login_as(@user, :scope => :user)
      visit edit_user_registration_path
    end

    after{ Warden.test_reset! }

    describe "#update" do
      before do
        fill_in 'user_name', with: "NewNname"
        fill_in 'user_email', with: 'new_mail@example.com'
        attach_file "user_image", Rails.root.join('spec', 'support', 'files', 'image.jpg')
        click_on 'Update'
      end

      it "update user's data" do
        @user.reload
        expect(@user.name).to eq "NewNname"
        expect(@user.email).to eq "new_mail@example.com"
        expect(@user.image.url).not_to eq "/images/original/missing.jpeg"
      end

      it "render user's show page" do
        expect(page.current_path).to eq account_path
      end
    end

    # TODO: Tests whit JS
    describe "#update_password" do
      context "user has password" do
        it "contain cuurent_password field" do
          expect(page).to have_selector "#user_current_password"
        end

        context "current_path is not fill" do
          before do
            fill_in 'user_password', with: "new_password"
            fill_in 'user_password_confirmation', with: "new_password"
            click_on 'Update Password'
          end

          it "render edit password page" do
            expect(page.current_path).to eq "/user/password/edit"
          end
        end

        context "current_password is fill" do
          before do
            fill_in 'user_password', with: "new_password"
            fill_in 'user_password_confirmation', with: "new_password"
            fill_in 'user_current_password', with: "12345678"
            click_on 'Update Password'
          end

          it "render show page" do
            expect(page.current_path).to eq account_path
          end
        end
      end

      context "users hasn't password" do
        before do
          @user.update({has_password: false})
          @user.reload
          visit edit_user_registration_path
        end

        it " not contain cuurent_password field" do
          expect(page).not_to have_selector "#account_password"
        end
        context "After fill password" do
          before do
            fill_in 'user_password', with: "new_password"
            fill_in 'user_password_confirmation', with: "new_password"
            click_on 'Set Password'
          end

          it "render show page" do
            expect(page.current_path).to eq account_path
          end

          it "set user has_password to true" do
            @user.reload
            expect(@user.has_password).to eq true
          end
        end
      end
    end


    describe "Facebook acount" do
      before { visit edit_user_registration_path}
      describe "user without facebook account" do
        it "contain link to add Facebook account" do
          expect(page).to have_link "FB add", user_omniauth_authorize_path(:facebook)
        end
      end

      describe "user with facebook account" do
        before do
          @user = FactoryGirl.create(:user_with_fb)
          login_as(@user, :scope => :user)
          visit edit_user_registration_path
        end
        after { Warden.test_reset! }

        it "contain link to remove Facebook account" do
          expect(page).to have_link "FB remove", remove_fb_account_path
        end

        describe "#remove_fb_account" do
          before { click_on "FB remove"}

          it "remove user's uid and provider" do
            @user.reload
            expect(@user.uid).to eq nil
            expect(@user.provider).to eq nil
          end

          it "redirect to show page" do
            expect(page.current_path).to eq account_path
          end
        end

        describe "user without set password" do
          before do
            @user.update({has_password: false})
            visit edit_user_registration_path
          end

          it "contain message" do
            expect(page).to have_content 'You must set your password to remove your facebook account'
          end
        end
      end
    end
  end

  context "user is unlogged" do
    describe "#update" do
      before { visit edit_user_registration_path }
      
      it 'gets redirected' do
        expect(page.current_path).to eq new_user_session_path
      end
    end
  end
end