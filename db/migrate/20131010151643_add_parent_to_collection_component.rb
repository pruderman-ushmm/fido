class AddParentToCollectionComponent < ActiveRecord::Migration
  def change
    change_table :collection_components do |t|
#      t.belongs_to :collection_component, :as => 'parent_id'
      t.integer 'parent_id'
    end
  end
end
