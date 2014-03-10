class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :reports
  accepts_nested_attributes_for :reports

  validates :name, presence: true
  validates :role, presence: true
  validates :role, :inclusion => { :in => %w(editor author) }

  def editor?
    self.role == "editor"
  end
end
