ActiveAdmin.register DigitalAsset do


	controller do
		def permitted_params
			params.permit digital_asset: [:page_transcript]
		end
	end

	index :as => :grid do |da|
		if da
			resource_selection_cell da
			para link_to(image_tag(da.derivative_url, {width: '100px'}), admin_digital_asset_path(da))
			para link_to(da.path_within_archive, da.url)
			if da.image_height and da.image_width
				para "Dimensions: #{da.image_width} x #{da.image_height}"
			else
				para "Dimensions: unknown"
			end
			para da.digital_asset_file
			para da.url
			para da.digital_asset_file.exists? ? 'Exists' : 'Does not exists'
			para da.derivative_file
			para da.derivative_url
			para da.derivative_file.exists? ? 'Exists' : 'Does not exists'
			exif_info = EXIFR::JPEG.new(da.digital_asset_file.absolute_path)
			if exif_info.exif?
		        h = exif_info.exif.to_hash
		        h.each_pair do |k,v|
		        	li "#{k.to_s}: #{v}"
		        end
	        end
		end
	end

	member_action :generate_derivative, method: :post do
	    @digital_asset = DigitalAsset.find(params[:id])

	    @digital_asset.delay.generate_derivative!

	    redirect_to(preview_collection_directory_admin_digital_collection_path(@digital_asset.collection_component.inherited_digital_collection), notice: "Derivative #{@digital_asset.derivative_file} (not actually) generated.")
	end

	member_action :destroy_derivative, method: :post do
	    @digital_asset = DigitalAsset.find(params[:id])

	    ## !!! delete derivative file here!

		redirect_to(preview_collection_directory_admin_digital_collection_path(@digital_asset.collection_component.inherited_digital_collection), notice: "Derivative #{@digital_asset.derivative_file} (not acutally) deleted.")
	end

	batch_action :generate_derivatives do |selection|
		selection.each { |r|
		    @digital_asset = DigitalAsset.find(r)

		    @digital_asset.delay.generate_derivative!
		}

	    redirect_to(admin_digital_assets_path, notice: "Derivatives queued for generation.")
	end

end
