class ContainerType < ActiveRecord::Base
	has_many :collection_components

	has_many :allowed_parent_type_mappings, :class_name => 'AllowedContainerTypeNesting', :foreign_key => 'allowed_child_id'
	has_many :allowed_child_type_mappings, :class_name => 'AllowedContainerTypeNesting', :foreign_key => 'allowed_parent_id'

	has_many :allowed_parent_types, :through => :allowed_parent_type_mappings, :source => 'allowed_parent'
	has_many :allowed_child_types, :through => :allowed_child_type_mappings, :source => 'allowed_child'
end


class AllowedContainerTypeNesting < ActiveRecord::Base
	belongs_to :allowed_parent, :class_name => "ContainerType"
	belongs_to :allowed_child, :class_name => "ContainerType"
end
