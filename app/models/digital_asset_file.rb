class DigitalAssetFile
#	include ActiveModel::Model  ## Perhaps one day

	def self.all
		raise "Cannot find all records.  Too many."
	end

	## !!! Generalize this function a bit more.  Remove reference to APP_SETTINGS.
	def self.get_possible_archive_folders archive_absolute_path
#		base_path_to_scan = File.join(APP_SETTINGS['digital_archive_root'], '**', '*')  ## The ** indicates recursion.
#		base_path_to_scan = File.join(APP_SETTINGS['digital_archive_root'], '*')
		base_path_to_scan = File.join(archive_absolute_path, '*')
		# Get the list of pathnames (as strings)
		full_abs_path_list = Dir.glob(base_path_to_scan)

		# Convert the array of strings into Pathname objects, change base path, then convert back to strings.
		z = Pathname.new(APP_SETTINGS['digital_archive_root'])

		rel_path_list = full_abs_path_list.map{ |y| (Pathname.new(y).relative_path_from(z).to_s)}

		return rel_path_list
	end


	## Treats the supplied folder as a "collection" and returns all file offspring, simlar to find(1) command.)
	def self.all_from_directory directory_absolute_path
		abs_list_spec = File.join(directory_absolute_path, '**', '*')  ## The ** indicates recursion.
		abs_file_list = Dir.glob(abs_list_spec).reject { |f| File.directory? f }  ## The ** indicates recursion.

		# Now, convert paths to relative form from supplied directory_absolute_path
		rel_file_list = abs_file_list.map{ |i| (Pathname.new(i).relative_path_from(Pathname.new(directory_absolute_path)).to_s)}
		object_list = rel_file_list.map { |f| new directory_absolute_path, f }
		return object_list
	end

	attr_reader :directory_absolute_path, :path_within_directory

	def initialize new_directory_absolute_path, new_path_within_directory
		@directory_absolute_path = new_directory_absolute_path
		@path_within_directory = new_path_within_directory
	end

	def name
		path_within_directory
	end
	def to_s
		# asset_path_within_directory
		absolute_path
	end

	def directory_absolute_path
		@directory_absolute_path
	end

	def path_within_directory
		@path_within_directory
	end

	def absolute_path
		directory_absolute_path + '/' + path_within_directory
	end

	def image_height
		unless @image_height
			hx = FsAssetLib::get_image_dimensions(absolute_path)
			@image_height = hx[:height]
			@image_width = hx[:width]
		end
		return @image_height
	end

	def image_width
		unless @image_width
			hx = FsAssetLib::get_image_dimensions(absolute_path)
			@image_height = hx[:height]
			@image_width = hx[:width]
		end
		return @image_width
	end

	def mime_type
		raise
		return nil
	end

	def digital_asset
		raise
		return nil
	end

	def match_into_digital_collection digital_collection
		matches = digital_collection.file_pattern.regular_expression.match (@path_within_directory)

		## If the filename does not match the pattern, return nil.
		unless matches
			# raise "'#{@asset_path_within_directory}' does not match pattern '#{digital_collection.file_pattern}'"
			return nil, nil, []
		end

		matches_hash = Hash[matches.names.zip(matches.captures)].each{ |_,str| if str.match(/^0/); str.replace str.to_i.to_s end }

		## Prepare a hash which will (eventually) only contain unused components.
		leftovers = matches_hash

		## Variable will hold the designation for the item (asset) when it can be determined.
		item_designation = nil

		## Start pointing at the collection passed in.
		current_component = digital_collection.collection_component

		## First, see if one of the matched parts matches the collection itself.
		## Also, check to see if any matched parts matches the "item" (asset) level component.
		## If so, remove it from the leftovers hash.
		matches_hash.each { |cl, dsg| 
			if current_component.component_level.short_name == cl and (current_component.designation == dsg.to_i.to_s or current_component.designation == dsg)
				leftovers.delete(cl)
			end
			if 'item' == cl
				item_designation = dsg
				leftovers.delete(cl)
			end
		}

		## Now loop thru the children of the collection:
		while true do
			matching_children = []

			# For each child component of the current "pointer" position, check to see if it matches part of the match.
			current_component.children.each { |cc|
				matches_hash.each { |cl, dsg| 
					if cc.component_level.short_name == cl and (cc.designation == dsg.to_i.to_s or cc.designation == dsg)
						matching_children << cc
					end
				}
			}

			## Now see how many children we have matched.
			## If it's 1, then descend and try to keep matching.
			## If none, return.
			## If more than one, raise an error.
			if matching_children.count == 1
				current_component = matching_children[0]
				leftovers.delete(matching_children[0].component_level.short_name)
				next
			elsif matching_children.count > 1
				raise "matched too many children"
			else
				return current_component, item_designation, leftovers ## No matches this time, just return wherever we've gotten, if anywhere.
			end
		end # while true

	end

	def exists?
		File.file? absolute_path
	end

end