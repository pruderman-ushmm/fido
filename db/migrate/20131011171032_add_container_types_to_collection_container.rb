class AddContainerTypesToCollectionContainer < ActiveRecord::Migration
  def change
    change_table :collection_containers do |t|
      t.belongs_to :container_type
#      t.integer 'parent_id'
    end
  end
end
