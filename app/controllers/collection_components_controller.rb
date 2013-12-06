class CollectionComponentsController < ApplicationController

	def index
		@collection_components = CollectionComponent.all
	end

	def show
		@collection_component = CollectionComponent.find(params[:id])
	end

	def new
		@collection_component = CollectionComponent.new
	end

	def create
#		@collection_component = Comment.new(params[:collection_component])
		@collection_component = CollectionComponent.new(collection_component_params)
		if @collection_component.save
			flash[:notice] = "Thanks for your comment!"
			# if params[:remember_name]
   #          	# Remember the commenter's name.
   #          	cookies[:commenter_name] = @collection_component.author
   #          else
	  #       # Delete cookie for the commenter's name cookie, if any.
	  #       cookies.delete(:commenter_name)
	    end
	    redirect_to @collection_component
	else
		render action: "new"

	end


	def update
		@collection_component = CollectionComponent.find(params[:id])
		@collection_component.update_attributes!(collection_component_params)
		if @collection_component.update(collection_component_params)
			redirect_to(@collection_component)
		else
			render :edit
		end
	end

	private

	def collection_component_params
#		params.require(:collection_component).permit(:parent_id, :title, :designation, :commit)
		raise RuntimeError
		params.require(:collection_component).permit!
	end



end
