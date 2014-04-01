class Report < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :editor, polymorphic: true
  belongs_to :destroyer, polymorphic: true

  belongs_to :category
  has_one :permissions, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :comments, dependent: :destroy
  # accepts_nested_attributes_for :pictures
  
  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true
  validates :category, presence: true

  accepts_nested_attributes_for :permissions

  after_create :set_permissions
  after_update :send_update_notification
  after_destroy :send_destroy_notification

  attr_accessor :can_edit,:can_read,:can_destroy
  private
    def send_update_notification
      if self.editor && self.user != self.editor
        Notification.create(user: self.user, sender: self.editor, message: "Your report #{self.title} was updated by administrator")
      end
    end

    def send_destroy_notification
      if self.destroyer && self.destroyer != self.user
        Notification.create(user: self.user, sender: self.destroyer, message: "Your report #{self.title} was deleted by administrator")
      end
    end

    def set_permissions
      Permissions.create(report: self) unless self.permissions
    end

end
