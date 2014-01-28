class OnlinePagesController < ApplicationController
	def permitted_params
		# params.require(:digital_asset).permit al_asset: [ { :page_number, :page_transcript } ]
		params.permit(:id, :submit, :authenticity_token, :_method, :commit, :action, :controller, :utf8, digital_asset: [ :id, :page_number, :page_transcript ])
	end

	def index
		@online_pages = OnlinePage.all
	end

	def show
		# @online_page = OnlinePage.find_by_designation(params[:designation])
		@online_page = OnlinePage.find(params[:id])
	end

	def edit
		@online_page = OnlinePage.find(params[:id])
	end

	def update
		# puts '--------'
		# puts params.inspect
		# puts '--------'
		# puts params.permit(:id, :submit, :authenticity_token, :_method, :commit, :action, :controller, :utf8, digital_asset: [ :id, :page_number, :page_transcript ]).inspect
		# puts '--------'

		# binding.pry
		# puts params[:id]

		@online_page = OnlinePage.find(permitted_params[:id])
		if @online_page.digital_asset.update_attributes(permitted_params[:digital_asset])
			# redirect_to :action => 'show', :id => @online_page
			redirect_to :action => 'index'
		else
			render :action => 'edit'
		end
	end





end
