class CreateOnlineBooks < ActiveRecord::Migration
  def change
    create_table :online_books do |t|
      t.string :title
      t.boolean :published
      t.references :collection_component

      t.timestamps
    end
  end
end
