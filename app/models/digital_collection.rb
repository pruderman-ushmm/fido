class DigitalCollection < ActiveRecord::Base
	belongs_to :collection_component
	belongs_to :file_pattern

	def absolute_path
		APP_SETTINGS['digital_archive_root'] + '/' + path_within_archive
	end
end
