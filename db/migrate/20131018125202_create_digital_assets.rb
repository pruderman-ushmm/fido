class CreateDigitalAssets < ActiveRecord::Migration
  def change
    create_table :digital_assets do |t|
      t.string :path_within_collection
      t.references :collection_component
      t.integer :image_height
      t.integer :image_width
      t.string :mime_type
      t.integer :page_number
      t.string :page_side
      t.string :page_title
      t.text :page_transcript

      t.timestamps
    end
  end
end
