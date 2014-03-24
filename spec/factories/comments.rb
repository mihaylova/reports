# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    text "Comment text"
    association :report, factory: :report
    association :user, factory: :user
  end
end
