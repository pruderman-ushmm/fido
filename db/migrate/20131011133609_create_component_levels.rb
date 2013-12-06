class CreateComponentLevels < ActiveRecord::Migration
  def change
    create_table :component_levels do |t|
      t.string :name
      t.string :short_name
    end
  end
end
