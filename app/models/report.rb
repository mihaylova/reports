class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  
  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true
  validates :category, presence: true
end
