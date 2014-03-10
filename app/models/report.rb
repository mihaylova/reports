class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_one :permissions
  
  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true
  validates :category, presence: true

  after_create :set_permissions

  def set_permissions
    Permissions.create(report: self)
  end
end
