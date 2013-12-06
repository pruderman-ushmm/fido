# encoding: utf-8

class CollectionComponent < ActiveRecord::Base
	belongs_to :component_level
	belongs_to :parent, :class_name => 'CollectionComponent', :foreign_key => 'parent_id'
	has_many :children, :class_name => 'CollectionComponent', :foreign_key => 'parent_id'
	has_many :digital_assets
	has_one :digital_collection

	validates :designation, presence: true
	validates :component_level, presence: true
	validate :component_nesting_is_valid

	before_destroy :no_child_components_or_assets?, :message => 'Yes, indeed.'


	def no_child_components_or_assets?
		if children.count == 0 and digital_assets.count == 0
			return true
		else
		    errors.add(:base, "This component has children.")  ## Note this error doesn't work b/c activeadmin is lame.
			return false
		end
	end

	def descendant_digital_assets
		all_digital_assets = []
		all_digital_assets.concat digital_assets.to_ary
		descendants.each { |d|
			all_digital_assets.concat d.digital_assets
		}
		return all_digital_assets
	end

	def descendants
		all_descendants = []

		## Better with or without this includes??  !!!
		children.includes(:children, :digital_assets).each { |c|
			all_descendants << c
			all_descendants.concat c.descendants
		}
		return all_descendants
	end



	def to_s
		#		parent_array.join('\\') { |t| t.full_designation}
		(parent ? parent.to_s : '') + component_level.name + ' ' + designation + ( title.blank? ? '' : (': “' + title + '”'))
		# full_designation
	end

	def component_nesting_is_valid
		if parent
			if parent.component_level.allowed_child_levels.include? component_level
				ret = true
			else
				if ! component_level
					errors.add(:parent, "no component level!")
				elsif ! parent.component_level
					errors.add(:parent, "parent has no component level") ## shouldn't happen
				else
					errors.add(:component_level, "can't nest a #{component_level.name} inside a #{parent.component_level.name}")
				end
				ret = false
			end
		else
			if component_level.short_name == :archive
				ret = true
			else
				ret = false
			end
		end
		ret
	end

	def full_designation
		# component_level.name + ' ' + designation + ( title.blank? ? '' : (': “' + title + '”'))
		component_level.name + ' ' + designation
	end


	def inherited_digital_collection
		ptr = self
		while ptr.digital_collection == nil
			print "Looking for parents!"
			unless ptr.parent
				raise "Ran out of parents!"
			end
			ptr = ptr.parent
		end
		return ptr.digital_collection
	end

	def parent_array
		if parent
			parent.parent_array << self
		else
			[self]
		end
	end

end
