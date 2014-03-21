class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  has_many :reports, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :sent_notifications, as: :sender, class_name: "Notification"
  has_many :edited_reports, as: :editor, class_name: "Report"
  has_many :destroyed_reports, as: :destroyer, class_name: "Report"
  belongs_to :last_editor, class_name: "AdminUser"


  accepts_nested_attributes_for :reports

  validates :name, presence: true

  after_update :send_notification

  has_attached_file :image, :styles => {:small => "50x50#", large: "700x700" }, :default_url => "/images/:style/missing.jpeg"

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/]



 def self.find_for_facebook_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
    unless user
      user = User.where(email: auth.info.email).first
      user = user ? user.add_fb_account(auth) : create_whit_fb_account(auth)
    end
    user
  end

  def has_fb_account?
    provider == "facebook" && uid
  end

  def add_fb_account(auth)
    self if self.update(uid: auth.uid, provider: auth.provider)
  end

  def self.create_whit_fb_account(auth)
    user = User.new(
      provider: auth.provider,
      uid: auth.uid,
      email:  auth.info.email,
      password:  Devise.friendly_token[0,20],
      name: auth.info.name,
      has_password: false
      )

    user if user.save
  end

  private
    def send_notification
      Notification.create(user: self, sender: self.last_editor, message: "Your profile was updated by administrator")
    end
end
