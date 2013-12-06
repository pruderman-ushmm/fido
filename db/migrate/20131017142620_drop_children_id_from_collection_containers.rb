class DropChildrenIdFromCollectionContainers < ActiveRecord::Migration
  def change
    remove_column :collection_containers, :children_id
  end
end
