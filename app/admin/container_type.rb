ActiveAdmin.register ContainerType do
	controller do
		def permitted_params
			params.permit container_type: [:name, :short_name, :allowed_parent_type_ids=>[], :allowed_child_type_ids=>[]]
		end
	end

	form do |f|
		f.inputs do
    	  	f.input :name
    	  	f.input :short_name
			f.input :allowed_parent_types, as: :check_boxes
			f.input :allowed_child_types, as: :check_boxes
    	end
   		f.actions
   	end

end
