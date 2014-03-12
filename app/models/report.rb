class Report < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :editor, polymorphic: true
  belongs_to :category
  has_one :permissions, dependent: :destroy
  
  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true
  validates :category, presence: true

  accepts_nested_attributes_for :permissions

  after_create :set_permissions
  after_update :send_notification


  private
    def send_notification
      if self.user != self.editor
        Notification.create(user: self.user, sender: self.editor, message: "Your report #{self.title} was updated by administrator")
      end
    end

    def set_permissions
      Permissions.create(report: self) unless self.permissions
    end

end
