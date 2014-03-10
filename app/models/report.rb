class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  has_one :permissions, dependent: :destroy
  
  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true
  validates :category, presence: true

  accepts_nested_attributes_for :permissions

  after_create :set_permissions


  def set_permissions
    Permissions.create(report: self) unless self.permissions
  end
end
