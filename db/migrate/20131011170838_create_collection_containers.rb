class CreateCollectionContainers < ActiveRecord::Migration
  def change
    create_table :collection_containers do |t|
      t.string :title
      t.string :designation
      t.references :parent
      t.references :children

      t.timestamps
    end
  end
end
