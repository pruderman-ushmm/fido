ActiveAdmin.register OnlineBook do
	controller do
		def permitted_params
			params.permit online_book: [ :title, :designation, :published, :collection_component_id, :digital_asset_ids=>[] ]
		end
	end


	form do |f|
		f.inputs do
			# f.input :collection_component, member_label: :to_s
			# f.input :path_within_archive, as: :select, collection: (DigitalAssetFile::get_possible_archive_folders APP_SETTINGS['digital_archive_root'])
			f.input :title
			f.input :designation
			f.input :collection_component, as: :select, member_label: :to_s
			f.input :published

			# f.input :digital_assets, as: :check_boxes, collection: DigitalAsset.where(collection_component_id: f.object.collection_component_id)
			f.input :digital_assets, as: :check_boxes, collection: f.object.collection_component.descendant_digital_assets
		end
		f.actions
	end


	index do
		column :title
		column :designation
		column :published
		column :collection_component
#		column :digital_assets

		# default_actions
	    actions defaults: true do |online_book|
	    	links = ''.html_safe
			links += link_to "Add all assets as pages", add_all_assets_as_pages_admin_online_book_path(online_book), :method => :post
			links += ' '
			links += link_to "Remove all pages", remove_all_pages_admin_online_book_path(online_book), :method => :post
			links
		end
	end


	member_action :add_all_assets_as_pages, method: :post do
	    @online_book = OnlineBook.find(params[:id])

	    @all_associated_assets = @online_book.collection_component.descendant_digital_assets

	    @online_book.digital_assets += @all_associated_assets
	    @online_book.save!

	    redirect_to({:action => :index}, :notice => "Online book assets associated.")
	end


	member_action :remove_all_pages, method: :post do
	    @online_book = OnlineBook.find(params[:id])

	    @online_book.digital_assets = []
	    @online_book.save!

	    redirect_to({:action => :index}, :notice => "Online book pages removed.")
	end

end
