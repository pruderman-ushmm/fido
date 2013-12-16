class AddDesignationToOnlineBooks < ActiveRecord::Migration
  def change
    change_table :online_books do |t|
      t.string :designation
    end
  end
end
