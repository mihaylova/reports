class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :reports, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :sent_notifications, as: :sender, class_name: "Notification"
  has_many :edited_reports, as: :editor, class_name: "Report"
  has_many :destroyed_reports, as: :destroyer, class_name: "Report"
  belongs_to :last_editor, class_name: "AdminUser"


  accepts_nested_attributes_for :reports

  validates :name, presence: true

  after_update :send_notification

  private
    def send_notification
      Notification.create(user: self, sender: self.last_editor, message: "Your profile was updated by administrator")
    end

end
