class RemoveOnlineBooksDigitalAssets < ActiveRecord::Migration
  def change
  	drop_table :online_books_digital_assets
  end
end
