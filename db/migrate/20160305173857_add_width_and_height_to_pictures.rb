class AddWidthAndHeightToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :width, :string
    add_column :pictures, :height, :string
  end
end
