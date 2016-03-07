class AddImageFileNameAndImageFileSizeToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :image_file_name, :string
    add_column :pictures, :image_file_size, :string
  end
end
