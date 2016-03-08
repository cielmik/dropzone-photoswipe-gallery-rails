class Album < ActiveRecord::Base
  has_many :pictures, dependent: :destroy

  attr_accessor :images, :title, :description

  def images=(files)
    files.each do |file|
      pictures.build(image: file.pop, title: title, description: description)
    end
  end
end
