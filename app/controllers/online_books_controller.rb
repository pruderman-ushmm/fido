class OnlineBooksController < ApplicationController

	def index
		@online_books = OnlineBook.all
	end

	def show
		@online_book = OnlineBook.find(params[:id])

		unsorted_pages_array = @online_book.pages.map do |page|
			unless page.derivative_file.exists?
				page.delay.generate_derivative!
			end

			{
				id: page.id,
				height: page.image_height,
				width: page.image_width,
				page_designation: page.id,
				page_side: 'L',
				url: page.url,
				derivative_url: page.derivative_url,
				transcript: page.page_transcript,
				designation: page.collection_component.designation
			}
		end
		@pages_hash = {};
		unsorted_pages_array.each { |i|
			@pages_hash[i[:id]] = i
		}

		@page_num_array = unsorted_pages_array.map { |a| a[:id] }.sort

		@online_book_json_data = @pages_hash.to_json


		respond_to do |responder|
			responder.html { render 'show2' }
			responder.json { render json: @online_book_json_data  }
		end
	end



end
