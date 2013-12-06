ActiveAdmin.register OnlineBook do
	controller do
		def permitted_params
			params.permit online_book: [ :title, :published, :collection_component_id, :digital_asset_ids=>[] ]
		end
	end


	form do |f|
		f.inputs do
			# f.input :collection_component, member_label: :to_s
			# f.input :path_within_archive, as: :select, collection: (DigitalAssetFile::get_possible_archive_folders APP_SETTINGS['digital_archive_root'])
			f.input :title
			f.input :collection_component, as: :select, member_label: :to_s
			f.input :published

			# f.input :digital_assets, as: :check_boxes, collection: DigitalAsset.where(collection_component_id: f.object.collection_component_id)
			f.input :digital_assets, as: :check_boxes, collection: f.object.collection_component.descendant_digital_assets
		end
		f.actions
	end


	index do
		column :title
		column :published
		column :collection_component
#		column :digital_assets

		default_actions
	end


end
