class ComponentLevel < ActiveRecord::Base
	has_many :collection_components

	has_many :allowed_parent_level_mappings, :class_name => 'AllowedComponentLevelNesting', :foreign_key => 'allowed_child_id'
	has_many :allowed_child_level_mappings, :class_name => 'AllowedComponentLevelNesting', :foreign_key => 'allowed_parent_id'

	has_many :allowed_parent_levels, :through => :allowed_parent_level_mappings, :source => 'allowed_parent'
	has_many :allowed_child_levels, :through => :allowed_child_level_mappings, :source => 'allowed_child'

	def to_s
		return name
	end
end


class AllowedComponentLevelNesting < ActiveRecord::Base
	belongs_to :allowed_parent, :class_name => "ComponentLevel"
	belongs_to :allowed_child, :class_name => "ComponentLevel"
end
