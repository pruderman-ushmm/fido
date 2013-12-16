class AddDesignationToDigitalAssets < ActiveRecord::Migration
  def change
    change_table :digital_assets do |t|
      t.string :designation
    end
  end
end
