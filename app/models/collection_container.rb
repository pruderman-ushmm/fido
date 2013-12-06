# encoding: utf-8

class CollectionContainer < ActiveRecord::Base
	validates :designation, presence: true
	validates :container_type, presence: true
	validate :container_nesting_is_valid

	def container_nesting_is_valid
		if parent
			if parent.container_type.allowed_child_types.include? container_type
				ret = true
			else
				errors.add(:parent, "can't nest a #{container_type.name} inside a #{parent.container_type.name}")
				ret = false
			end
		else
			ret = false
		end
		ret
	end

	def full_designation
		container_type.name + ' ' + designation + ( title.blank? ? '' : (': “' + title + '”'))
	end

	belongs_to :container_type
	belongs_to :parent, :class_name => 'CollectionContainer', :foreign_key => 'parent_id'
	has_many :children, :class_name => 'CollectionContainer', :foreign_key => 'parent_id'
end
