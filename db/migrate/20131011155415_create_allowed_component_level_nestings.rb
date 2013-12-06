class CreateAllowedComponentLevelNestings < ActiveRecord::Migration
  def change
    create_table :allowed_component_level_nestings do |t|
      t.integer :allowed_parent_id
      t.integer :allowed_child_id
    end
  end
end
