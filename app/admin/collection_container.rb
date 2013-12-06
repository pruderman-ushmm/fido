# encoding: utf-8

ActiveAdmin.register CollectionContainer do
	controller do
		def permitted_params
			params.permit collection_container: [:parent_id, :title, :designation, :container_type_id]
		end
	end
	index do
		column "Full Designation" do |cc|
			link_to(cc.full_designation, admin_collection_container_path(:id => cc.id))
		end
		column :parent
		column "Chidren" do |cc|
			cc.children.each { |c|
				li c.full_designation
			}
		end

		default_actions
	end

	show do
		h3 collection_container.full_designation

		table_for collection_container.children do
			column "Full Designation" do |cc|
				link_to(cc.full_designation, admin_collection_container_path(:id => cc.id))
			end

			column "Chidren" do |cc|
				cc.children.each { |c|
					li link_to(c.full_designation, admin_collection_container_path(:id => c.id))
				}
			end
		end
	end
end
