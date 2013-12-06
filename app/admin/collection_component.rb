# encoding: utf-8

ActiveAdmin.register CollectionComponent do
	controller do
		def permitted_params
			p 'x' * 30
			p params.inspect
			p 'x' * 30
			params.permit collection_component: [:parent_id, :title, :designation, :component_level_id]
			#	  params.require(:collection_component).permit!
		end
# 		def collectionx
# #			@collection_components ||= CollectionComponent.includes(:component_level).page(1).per(10)
# 			# @collection_components ||= CollectionComponent.includes(:component_level)
# 			scope = CollectionComponent.scoped
# 			@collection_components = scope.page()
# 		end
		# def index
#			@collection_components ||= CollectionComponent.includes(:component_level).page()
			# @collection_components ||= CollectionComponent.all.page(params[:page]).per(10)
		# end
		# def index
		# 	index! do |xxx|
		# 		raise @collection_components.inspect
		# 		@collection_components ||= CollectionComponent.includes(:component_level)
		# 	end
		# end


	end

	form do |f|

		f.inputs do
			if params[:component_level]
				component_level_id = ( ComponentLevel.find_by short_name: params[:component_level] ).id
				f.input :component_level_id, as: :hidden, input_html: { value: component_level_id }
			else
				f.input :component_level
			end

			if params[:designation]
				f.input :designation, as: :hidden, input_html: { value: params[:designation] }
			else
				f.input :designation
			end

			f.input :title

			if params[:parent]
				f.input :parent_id, as: :hidden, input_html: { value: params[:parent] }
			else
				f.input :parent, member_label: :to_s
			end


		end

		f.actions do
			f.submit
		end

	end


	index do
		column "Component" do |cc|
			(cc.parent_array.map { |pc| '<b>' + pc.component_level.name + '</b>' + ' [' + pc.designation + '] <i>“' + pc.title + '”</i>' }.join ' › <br/>').html_safe
		end
		# column "Title" do |cc|
		# 	cc.parent_array.map { |pc| pc.title}.join ' › '
		# end
		# column "Designation" do |cc|
		# 	cc.parent_array.map { |pc| pc.designation}.join ' › '
		# end
		# column :parent do |p|
		# 	if p.parent
		# 		link_to(p.parent.full_designation, admin_collection_component_path(:id => p.parent.id))
		# 	end
		# end
		column "Chidren" do |cc|
			cc.children.sort! {|a,b| a.designation <=> b.designation}.each { |c|
				li link_to(c.full_designation, admin_collection_component_path(:id => c.id))
			}
		end

		default_actions
	end

	if true
	show do |cc|
		h3 collection_component
		attributes_table do
			row :id
			row :title
			row :designation
			row :created_at
			row :updated_at
			row :parent
			row :children
			row :component_level
		end

		div 'class' => :panel do
			h3 collection_component
			div 'class' => 'panel_contents' do
			div 'class' => 'attributes_table' do
				table do
					tr('class' => :row) do
						th "Title"
						td do
							if cc.title and cc.title != ''
								cc.title
							else
								span(:class => :empty) do
									'Empty'
								end
							end
						end
					end
					# tr do
					# 	td "Designation"
					# 	td designation
					# end
					tr('class' => :row) do
						th "Created at"
						td cc.created_at.to_formatted_s(:long)
					end
					tr('class' => :row) do
						th "Updated at"
						td cc.updated_at.to_formatted_s(:long)
					end
					tr('class' => :row) do
						th "Parent"
						td cc.parent
					end
					tr('class' => :row) do
						th "Children"
						td do
							ul do
								cc.children.each { |ccc|
									li link_to ccc.full_designation, admin_collection_component_path(ccc)
								}
							end
						end
					end
					tr('class' => :row) do
						th "Component Level"
						td cc.component_level
					end
				end
			end
			end
		end
	end
	end
end
