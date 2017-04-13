class Image < ActiveRecord::Base
  belongs_to :profile
  mount_uploader :attachment, AttachmentUploader

  def self.save_image(image, profile)
    img = self.new
    img.attachment = image
    img.profile = profile
    img.save
    img
  end

  def update_image(image)
    self.attachment = image
    self.save
    self
  end

end
