class OnlinePagesController < ApplicationController
	def permitted_params
		# params.require(:digital_asset).permit al_asset: [ { :page_number, :page_transcript } ]
		params.permit(:id, :submit, :authenticity_token, :_method, :commit, :action, :controller, :utf8, digital_asset: [ :id, :page_number, :page_transcript ])
	end

	def index
		@online_pages = OnlinePage.all
	end

	def old_show
		# @online_page = OnlinePage.find_by_designation(params[:designation])
		@online_page = OnlinePage.find(params[:id])
	end

	def edit
		@online_page = OnlinePage.find(params[:id])
	end

	def update
		@online_page = OnlinePage.find(permitted_params[:id])
		if @online_page.digital_asset.update_attributes(permitted_params[:digital_asset])
			# redirect_to :action => 'show', :id => @online_page
			redirect_to :action => 'index'
		else
			render :action => 'edit'
		end
	end

	def lookup_page book_designation, page_designation
		## A helper method.
		@online_book = OnlineBook.find_by_designation(book_designation)
		matching_pages = @online_book.pages.select { |x| x.designation == page_designation }
		page = matching_pages[0]
		@online_page =
			{
				# id: page.id,
				id: page.designation.to_i,
				height: page.image_height,
				width: page.image_width,
				derivative_height: (100).to_s,
				derivative_width: (100 * (page.image_width.to_f / page.image_height.to_f)).to_i.to_s,
				page_side: 'L',
				url: page.url,
				derivative_url: page.derivative_url,
				transcript: page.page_transcript,
				# designation: page.collection_component.designation
				designation: page.designation
			}

		@next_page = @online_page
		@prev_page = @online_page

	## Get all pages for thumbnails:
	unsorted_pages_array = @online_book.pages.map do |page|
			{
				# id: page.id,
				id: page.designation.to_i,
				height: page.image_height,
				width: page.image_width,
				derivative_height: (100).to_s,
				derivative_width: (100 * (page.image_width.to_f / page.image_height.to_f)).to_i.to_s,
				page_side: 'L',
				url: page.url,
				derivative_url: page.derivative_url,
				transcript: page.page_transcript,
				# designation: page.collection_component.designation
				designation: page.designation
			}
		end
		@pages_hash = {};
		unsorted_pages_array.each { |i|
			@pages_hash[i[:id]] = i
		}

		# Sort the array (which is keyed by id) according to page designation:
		@page_num_array = unsorted_pages_array.map { |a| a[:id] }.sort { |b,c| @pages_hash[b][:designation].to_i <=> @pages_hash[c][:designation].to_i }

		@user_ip = request.remote_ip


	end

	def show
		lookup_page params[:book_designation], params[:page_designation]

		respond_to do |responder|
			responder.html { render 'show.html', layout: 'new' }
			# responder.json { render json: @online_book_json_data  }
		end
	end

	def show_transcript
		lookup_page params[:book_designation], params[:page_designation]

		respond_to do |responder|
			responder.html { render 'transcript.html', layout: 'new' }
			# responder.json { render json: @online_book_json_data  }
		end
	end

end
