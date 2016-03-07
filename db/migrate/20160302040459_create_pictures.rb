class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :title
      t.text :description
      t.references :album, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
