FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@example.com"
    end

    password 12345678
    password_confirmation 12345678

    #first_name "FirstName"
    #last_name "Lastname"
    #birthday 20.years.ago
    #location "Same location"
    #picture "url_to_picture"

    #factory :user_with_avatar do
     # avatar { fixture_file_upload(Rails.root.join('spec', 'photos', 'image.jpeg'), 'image/jpg') }
    #end

    #factory :user_with_fb do
    #  provider "facebook"
    #  uid 123123123131231321
    #end

    #factory :admin do
     # role "admin"
    #end
  end
end