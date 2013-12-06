class CreateOnlineBookDigitalAssets < ActiveRecord::Migration
  def change
    create_table :online_book_digital_assets do |t|

      t.timestamps
    end
  end
end
