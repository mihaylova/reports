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


  def set_permissions
    Permissions.create(report: self) unless self.permissions
  end

  def self.updated_or_deleted?(id, action)
    #TODO: Refactoring
    report = Report.find_by_id(id)
    (!report && action == "deleted") || (action == "updated" && report.updated_at >= 3.seconds.ago)
  end
end
