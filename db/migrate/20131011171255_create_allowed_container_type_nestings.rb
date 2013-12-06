class CreateAllowedContainerTypeNestings < ActiveRecord::Migration
  def change
    create_table :allowed_container_type_nestings do |t|
      t.integer :allowed_parent_id
      t.integer :allowed_child_id
    end
  end
end
