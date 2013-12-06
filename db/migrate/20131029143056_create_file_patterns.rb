class CreateFilePatterns < ActiveRecord::Migration
  def change
    create_table :file_patterns do |t|
      t.string :pattern

      t.timestamps
    end
  end
end
