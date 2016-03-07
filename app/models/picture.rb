class Picture < ActiveRecord::Base
  belongs_to :album
  mount_uploader :image, ImageUploader
  before_save :update_image_attributes

  # rename json thumbnail url to just path instead of image.thumb.url
  def path
    image.thumb.url
  end

  # rename image_file_name and image_file_size to be used on javascript
  def as_json(options = { })
    h = super(options)
    h["name"] = h.delete "image_file_name"
    h["size"] = h.delete "image_file_size"
    h
  end

  private
    def update_image_attributes
      if image.present? && image_changed?
        self.image_file_size = image.file.size
        self.image_file_name = image.file.filename
      end
    end

end
