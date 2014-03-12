class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sent_notifications, as: :sender, class_name: "Notification"
  has_many :edited_reports, as: :editor, class_name: "Report"
  has_many :edited_users, class_name: "User", as: :last_editor
  has_many :destroyed_reports, as: :destroyer, class_name: "Report"
end
