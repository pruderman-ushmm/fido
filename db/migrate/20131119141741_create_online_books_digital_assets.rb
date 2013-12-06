class CreateOnlineBooksDigitalAssets < ActiveRecord::Migration
  def change
    create_table :online_books_digital_assets do |t|
    	t.belongs_to :online_book
    	t.belongs_to :digital_asset
    end
  end
end
