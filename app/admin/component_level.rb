ActiveAdmin.register ComponentLevel do
	controller do
		def permitted_params
			params.permit component_level: [:name, :short_name, :allowed_parent_level_ids=>[], :allowed_child_level_ids=>[]]
		end
	end

	form do |f|
		f.inputs do
    	  	f.input :name
    	  	f.input :short_name
			f.input :allowed_parent_levels, as: :check_boxes
			f.input :allowed_child_levels, as: :check_boxes
    	end
   		f.actions
   	end

end
