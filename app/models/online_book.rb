class OnlineBook < ActiveRecord::Base
	belongs_to :collection_component

	has_many :online_pages
	has_many :digital_assets, through: :online_pages

	def old_pages
		puts "Found #{collection_component.descendant_digital_assets.count} pages."
		collection_component.descendant_digital_assets
	end
	def pages
		digital_assets.includes(:collection_component)
	end
end
