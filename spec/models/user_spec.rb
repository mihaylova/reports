require 'spec_helper'

describe User do

  it { should have_many(:reports).dependent(:destroy) }
  it { should have_many(:notifications).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should have_many(:edited_reports) }
  it { should have_many(:destroyed_reports) }
  it { should have_many(:sent_notifications) }
  it { should belong_to(:last_editor)}
  it { should have_attached_file(:image) }
  it { should validate_attachment_content_type(:image).
                allowing('image/png', 'image/gif') }


  context "OmniAuth login" do
    let!(:auth_hash) { Object.new }

    before do
      auth_hash.stub(:uid).and_return "123456"
      auth_hash.stub(:provider).and_return "facebook"
      auth_hash.stub_chain(:info, :email).and_return "some@mail.com"
      auth_hash.stub_chain(:info, :name).and_return "Some name"
      auth_hash.stub_chain(:info, :location).and_return "Some location"
      auth_hash.stub_chain(:info, :image).and_return "URL to image"
    end

    it "return right value" do
      auth_hash.uid.should eq "123456"
      auth_hash.provider.should eq "facebook"
      auth_hash.info.email.should eq "some@mail.com"
      auth_hash.info.name.should eq "Some name"
      auth_hash.info.location.should eq "Some location"
      auth_hash.info.image.should eq "URL to image"
    end

    describe "find_for_facebook_oauth" do
      let(:fb_user) { User.find_for_facebook_oauth(auth_hash) }

      context "On wrong data/some problem whit save/update" do
        describe "create user" do
          before { User.any_instance.should_receive(:save).and_return(false) }
          it "should return nil" do
            fb_user.should eq nil
          end
        end

        describe "add fb account to user" do
          let!(:user) {FactoryGirl.create(:user, email: auth_hash.info.email)}
          before { User.any_instance.should_receive(:save).and_return(false) }

          it "should return nil" do
            fb_user.should eq nil
          end
        end
      end

      context "find user with fb account" do
        let!(:user) {FactoryGirl.create(:user, uid: auth_hash.uid, provider: auth_hash.provider)}

        it "should returns this user" do
            fb_user.should eq user
        end

        it "shouldn't  create new user" do
          expect { fb_user }.not_to change { User.count }
        end
      end

      context "create user" do
        it "should returns user whit data from auth_hash" do
          fb_user.uid.should eq auth_hash.uid
          fb_user.provider.should eq auth_hash.provider
          fb_user.email.should eq auth_hash.info.email
          fb_user.name.should eq auth_hash.info.name
          fb_user.fb_picture.should eq auth_hash.info.image
          fb_user.location.should eq auth_hash.info.location
          fb_user.has_password.should eq false
        end

        it "should create new user" do
          expect {fb_user }.to change { User.count }.by(1)
        end
      end

      context "add fb account to user" do
         let!(:user) {FactoryGirl.create(:user, email: auth_hash.info.email)}

        it "should returns this user" do
          fb_user.should eq user
        end

        it "should set user's uid and provider form  auth_hash" do
          fb_user.uid.should eq auth_hash.uid
          fb_user.provider.should eq auth_hash.provider
        end

        it "should set user's data form  auth_hash if it's nil in db" do
          fb_user.location.should eq auth_hash.info.location
          fb_user.fb_picture.should eq auth_hash.info.image
        end

        it "shouldn't  create new user" do
          expect { fb_user }.not_to change { User.count }
        end
      end
    end
  end 
end