ActiveAdmin.register FilePattern do
	controller do
		def permitted_params
			params.permit file_pattern: [:pattern]
		end
	end
end
