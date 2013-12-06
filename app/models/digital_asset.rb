class DigitalAsset < ActiveRecord::Base
	belongs_to :collection_component
	scope :by_digital_collection, ->(digital_collection) { where("digital_collection = ?", digital_collection) }
	has_many :online_pages
	has_many :online_books, through: :online_pages

	validates :path_within_collection, presence: true, uniqueness: {scope: :collection_component, message: "should only be in collection once"}
	validates :collection_component, presence: true

	def url
		APP_SETTINGS['digital_archive_root_url'] + '/' + collection_component.inherited_digital_collection.path_within_archive + '/' + path_within_collection
	end

	def derivative_url
		APP_SETTINGS['digital_archive_derivative_root_url'] + '/' + collection_component.inherited_digital_collection.path_within_archive + '/' + derivative_file.path_within_directory
	end

	def abs_path
		APP_SETTINGS['digital_archive_root'] + '/' + collection_component.inherited_digital_collection.path_within_archive + '/' + path_within_collection
	end

	def path_within_archive
		unless collection_component
			raise "No associated CollectionComponent"
		end
		unless collection_component.inherited_digital_collection
			raise "The associated CollectionComponent (#{collection_component}) has no inherited DigitalCollection."
		end
		collection_component.inherited_digital_collection.path_within_archive + '/' + path_within_collection
	end

	def digital_asset_file
		unless @digital_asset_file  ## digital_asset_file
			unless collection_component
				raise "No associated CollectionComponent"
			end
			unless collection_component.inherited_digital_collection
				raise "The associated CollectionComponent (#{collection_component}) has no inherited DigitalCollection."
			end

			@digital_asset_file = DigitalAssetFile.new (APP_SETTINGS['digital_archive_root'] + '/' + collection_component.inherited_digital_collection.path_within_archive), path_within_collection
		end
		@digital_asset_file
	end

	def digital_asset_file= new_digital_asset_file
		@digital_asset_file = new_digital_asset_file
	end

	def derivative_file
		unless @derivative_asset_file
			@derivative_file = DigitalAssetFile.new (APP_SETTINGS['digital_archive_derivative_root'] + '/' + collection_component.inherited_digital_collection.path_within_archive), path_within_collection
		end
		@derivative_file
	end


	## If this DigitalAsset object is being newly created, it is likely from a DigitalAssetFile object.
	## Allow this DAF object to be assigned, so we don't need to create it implicitly later.
	# def digital_asset_file= digital_asset_file_object
	# 	@digital_asset_file = digital_asset_file_object
	# end

	def image_height
		unless read_attribute(:image_height)
			unless digital_asset_file
				return nil
			end
			write_attribute(:image_height, digital_asset_file.image_height)
			write_attribute(:image_width, digital_asset_file.image_width)
			save!
		end
		read_attribute(:image_height)
	end

	def image_width
		unless read_attribute(:image_width)
			unless digital_asset_file
				return nil
			end
			write_attribute(:image_height, digital_asset_file.image_height)
			write_attribute(:image_width, digital_asset_file.image_width)
			save!
		end
		read_attribute(:image_width)
	end

	def generate_derivative!
		derivative_type = :booksize
		case derivative_type
		when :thumbnail
			new_height = 300
			new_width = 300
		when :booksize
			new_height = 1000
			new_width = 1000
		else
			raise "Don't know how to generate derivative_type: #{derivative_type}."
		end

		derivative_abs_path = derivative_file.absolute_path
		original_abs_path = digital_asset_file.absolute_path

		## If this is a directory (not a file), skip it:
		unless File.directory?(File.dirname(original_abs_path))
			raise "Directory passed as original_abs_path to #generate_image_derivative.  Cannot make a derivative out of a directory."
		end

		## Make all of the intermediate directories to the file.
		unless File.directory?(File.dirname(derivative_abs_path))
			FileUtils.mkdir_p(File.dirname(derivative_abs_path))
		end

		## Does the path exist in the derivative tree?
		if (! derivative_file.exists?)
			command = Shellwords.join(["/usr/bin/convert", '-verbose', original_abs_path.to_s, '-resize', new_width.to_s+'x'+new_height.to_s, derivative_abs_path.to_s])
			command_output = `#{command}`
			exit_value = $?
			if (exit_value != 0)
				raise "Derivative generation failed: #{command_output}"
			end
		else
			return false
			raise "Aborting derivative generation.  File already exists: '#{derivative_abs_path}'"
		end
	end
end
