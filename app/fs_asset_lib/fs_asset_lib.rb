module FsAssetLib


	def self.get_possible_archive_folders
		base_path_to_scan = File.join(APP_SETTINGS['digital_archive_root'], '*')

		# Get the list of pathnames (as strings)
		full_abs_path_list = Dir.glob(base_path_to_scan)

		# Convert the array of strings into Pathname objects, change base path, then convert back to strings.
		z = Pathname.new(APP_SETTINGS['digital_archive_root'])

		rel_path_list = full_abs_path_list.map{ |y| (Pathname.new(y).relative_path_from(z).to_s)}

		return rel_path_list
	end




	def self.get_image_dimensions abs_path
		# Run the external command:
		command = Shellwords.join(["/usr/bin/rdjpgcom", '-v',  abs_path])+" 2>&1"
		command_output_all = `#{command}`
		command_output = command_output_all.split("\n")[0]

		if (command_output == "Not a JPEG file")
			@derivative_exists = false
			return
		end

		regular_expression_pattern = /^JPEG image is ([0-9]+)w . ([0-9]+)h/
		match_result = regular_expression_pattern.match(command_output)
		if match_result == nil
			error_message = "Unable to interpret output from rdjpgcom.\ncommand: " + command + "\ncommand_output: " + command_output_all + "\nregex: " + regular_expression_pattern.to_s
			raise RuntimeError.new(error_message)
		else
			derivative_width = match_result[1]
			derivative_height = match_result[2]
			return { width: derivative_width, height: derivative_height }
		end
	end


end
