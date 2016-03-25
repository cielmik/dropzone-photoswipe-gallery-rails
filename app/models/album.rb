class Album < ActiveRecord::Base
  has_many :pictures, dependent: :destroy

  attr_accessor :images, :title, :description

  def images=(files)
    if files
      files.each do |file|
        pictures.build(image: file.pop)
      end
    end
  end
end
