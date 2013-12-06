class AddComponentLevelsToCollectionComponent < ActiveRecord::Migration
  def change
    change_table :collection_components do |t|
      t.belongs_to :component_level
#      t.integer 'parent_id'
    end	
  end
end
