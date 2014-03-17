class Picture < ActiveRecord::Base
  belongs_to :report

  has_attached_file :image, :styles => {:small => "50x50#", large: "700x700" }, :default_url => "/images/:style/missing.jpeg"

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/]
end
