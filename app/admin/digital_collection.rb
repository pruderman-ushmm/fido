# main execution context
module Admin
	module IngestionHelper
	   def self.ingest digital_asset_file_object, digital_collection
	    	# num_ingested = 0
			collection_component_classification, item_designation, leftovers = digital_asset_file_object.match_into_digital_collection digital_collection


			unless collection_component_classification
				return false
				# raise "Classification failed: Could not classify '#{digital_asset_file_object}' into '#{digital_collection}'"
			end
			unless leftovers.count == 0
				return false
		    	# raise "There are leftovers: " + (leftovers.keys.join ', ')
			end

			da = DigitalAsset.new
	   		da.digital_asset_file = digital_asset_file_object
			da.path_within_collection = digital_asset_file_object.path_within_directory
			da.collection_component = collection_component_classification
			da.designation = item_designation
			if da.valid?
	    		da.save!
	    		return true
			end
			return false
	    end
    end
end


ActiveAdmin.register DigitalCollection do
	#<ActiveAdmin::ResourceDSL> EXECUTION CONTEXT

	action_item only: :show do
		link_to "Generate All Derivatives", generate_all_asset_derivatives_admin_digital_collection_path(digital_collection), method: :post
	end
	action_item only: :show do
		link_to "Scan Collection Directory", preview_collection_directory_admin_digital_collection_path(digital_collection)
	end


	controller do
		def permitted_params
			params.permit digital_collection: [:collection_component_id, :path_within_archive, :file_pattern_id]
		end
	end


	member_action :generate_all_asset_derivatives, method: :post do
		num_queued = 0
	    @digital_collection = DigitalCollection.find(params[:id])
	    @digital_collection.collection_component.descendant_digital_assets.each do |dda|
	    	unless dda.derivative_file.exists?
	    		dda.delay.generate_derivative!
	    		num_queued += 1
	    	end
	    end

		if num_queued == 0
		    redirect_to({:action => :preview_collection_directory}, flash: {error: "#{num_queued} assets queued."})
		else
		    redirect_to({:action => :preview_collection_directory}, :alert => "#{num_queued} assets queued.")
		end
	end

	member_action :preview_collection_directory, method: :get do
	    @digital_collection = DigitalCollection.find(params[:id])

    	## Retrieve the file list from the filesystem...
    	@digital_asset_file_object_list = DigitalAssetFile.all_from_directory(@digital_collection.absolute_path)

    	if ! File.exists? @digital_collection.absolute_path
    		@big_error = "Collections directory does not exist: #{@digital_collection.absolute_path}"
    	elsif @digital_asset_file_object_list.count > 0
			####################################################################
	    	@annotated_digital_asset_file_object_list = @digital_asset_file_object_list.map { |f|
	    		classification, item_designation, leftovers = f.match_into_digital_collection @digital_collection
	    		
	    		## Find the asset's resource if it has already been ingested.
	    		digital_asset_object = DigitalAsset.find_by path_within_collection: f.path_within_directory
	    		
	    		{
	    			digital_asset_file: f,
	    			classification: classification,
	    			leftovers: leftovers,
	    			item_designation: item_designation,
	    			digital_asset_object: digital_asset_object
	    		}
	    	}
			####################################################################
		else
    		@big_error = "No files found in: #{@digital_collection.absolute_path}"
		end
	end


	member_action :ingest_asset, method: :post do
    	@digital_collection = DigitalCollection.find(params[:id])

    	unless params[:asset_path_within_collection]
	    	raise "Need asset_path_within_collection passed as URL param."
	    end

    	digital_asset_file_object = DigitalAssetFile.new @digital_collection.absolute_path, params[:asset_path_within_collection]
  #   	da = DigitalAsset.new
  #   	da.path_within_collection = params[:asset_path_within_collection]

		# classification, item_designation, leftovers = digital_asset_file_object.match_into_digital_collection @digital_collection

		# raise ArgumentError, classification
    	if Admin::IngestionHelper.ingest digital_asset_file_object, @digital_collection
		    redirect_to({:action => :preview_collection_directory}, :notice => "Asset ingested successfully.")
		else
		    redirect_to({:action => :preview_collection_directory}, :flash => { :error => "Asset ingest failed."})
		end
	end



	member_action :uningest_asset, method: :post do
	    redirect_to({action: :preview_collection_directory, resource: :digital_asset_file}, notice: "Asset un-ingested successfully.")
	end


	## Ingest files from the defined collection, creating digital assets object for each.
    member_action :ingest_collection_directory, method: :post do
		#<Admin::DigitalCollectionsController> EXECUTION CONTEXT

    	@digital_collection = DigitalCollection.find(params[:id])

    	## Retrieve the file list from the filesystem...
    	digital_asset_file_object_list = DigitalAssetFile.all_from_directory(@digital_collection.absolute_path)

    	num_ingested = 0
    	num_skipped = 0
    	digital_asset_file_object_list.each { |f|
	    	if Admin::IngestionHelper.ingest f, @digital_collection
	    		num_ingested += 1
	    	else
	    		num_skipped += 1
	    	end
    	}

    	if num_skipped == 0
		    redirect_to({:action => :preview_collection_directory}, :notice => "#{num_ingested} assets ingested successfully.")
		else
			if num_ingested == 0
			    redirect_to({:action => :preview_collection_directory}, flash: {error: "#{num_ingested} assets ingested successfully, #{num_skipped} skipped."})
			else
			    redirect_to({:action => :preview_collection_directory}, :alert => "#{num_ingested} assets ingested successfully, #{num_skipped} skipped.")
			end
		end
    end


	form do |f|
		f.inputs do
#			if params[:parent]
				f.input :collection_component, member_label: :to_s
#			else
#				f.input :collection_component, as: :hidden, input_html: { value: params[:parent] }
#			end

#			f.input :path_within_archive, as: :select, collection: FsAssetLib::get_possible_archive_folders
			f.input :path_within_archive, as: :select, collection: (DigitalAssetFile::get_possible_archive_folders APP_SETTINGS['digital_archive_root'])
			f.input :file_pattern, as: :select
		end
		f.actions do
			f.action :submit, label: "Create Digital collection"  ## !!! -- Button says "create" even on update.  Fix!!!
			f.action :cancel, label: "Cancel"#, :as => :button
		end
	end

	index do
		column :id
		column :collection_component
		column :path_within_archive
		column :file_pattern
		# default_actions
	    actions defaults: true do |digital_collection|
			link_to "Scan Directory", preview_collection_directory_admin_digital_collection_path(digital_collection), :method => :get
		end

	end


	show do
      	attributes_table do
        	row :id
        	row :collection_component
        	row :path_within_archive
        	row :file_pattern
        	row :created_at
        	row :updated_at
        	# row :image do
        	# 	image_tag(ad.image.url)
        	# end
     	end
    	active_admin_comments

	end

end
