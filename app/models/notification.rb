class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :sender, polymorphic: true
end
