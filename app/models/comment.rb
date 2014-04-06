class Comment < ActiveRecord::Base
  belongs_to :report
  belongs_to :user

  validates :user, presence: true
  validates :report, presence: true
  validates :text, presence: true

  attr_accessor :can_edit, :can_destroy, :author_name, :updated

  def updated?
    self.created_at != self.updated_at
  end
end
