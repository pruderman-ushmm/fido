class CreateOnlinePages < ActiveRecord::Migration
  def change
    create_table :online_pages do |t|
      t.references :digital_asset
      t.references :online_book

      t.timestamps
    end
  end
end
