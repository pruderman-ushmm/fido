class AddFilePatternToDigitalCollection < ActiveRecord::Migration
  def change
    change_table :digital_collections do |t|
      t.references :file_pattern
    end
  end
end
