# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end

    password 12345678
    password_confirmation 12345678
    name "Ina Mihailova"
    editor true

    factory :user_with_fb do
      provider "facebook"
      uid 123123123131231321
    end
  end
end
