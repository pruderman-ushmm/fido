class DropOnlineBookDigitalAssets < ActiveRecord::Migration
  def change
  	drop_table :online_book_digital_assets
  end
end
