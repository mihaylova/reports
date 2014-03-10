class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :reports, dependent: :destroy
  has_many :notifications, dependent: :destroy

  accepts_nested_attributes_for :reports

  validates :name, presence: true

  def updated?
    self.updated_at >= 3.seconds.ago
  end

end
