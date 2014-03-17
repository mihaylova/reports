class Picture < ActiveRecord::Base
  belongs_to :report

  has_attached_file :image, :styles => {:small => "200x200#", large: "1000x1000>" }

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/]
  validates_attachment_presence :image
end
