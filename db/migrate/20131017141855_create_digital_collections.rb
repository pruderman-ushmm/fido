class CreateDigitalCollections < ActiveRecord::Migration
  def change
    create_table :digital_collections do |t|
      t.string :path_within_archive
      t.references :collection_component

      t.timestamps
    end
  end
end
