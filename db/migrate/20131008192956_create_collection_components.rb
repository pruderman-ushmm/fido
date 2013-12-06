class CreateCollectionComponents < ActiveRecord::Migration
  def change
    create_table :collection_components do |t|
      t.string :title
      t.string :designation
      t.references :parent
      t.references :children

      t.timestamps
    end
  end
end
