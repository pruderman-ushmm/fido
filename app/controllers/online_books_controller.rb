class OnlineBooksController < ApplicationController

	def index
		@online_books = OnlineBook.all
	end

	def show
		# if params[:id] == '2001.62.14'
		# 	id_to_lookup = 2
		# else
		# 	id_to_lookup = params[:id]
		# end
		# @online_book = OnlineBook.find(id_to_lookup)
		@online_book = OnlineBook.find_by_designation(params[:designation])

		unsorted_pages_array = @online_book.pages.map do |page|
			unless page.derivative_file.exists?
				# page.delay.generate_derivative!
			end

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

		@online_book_json_data = @pages_hash.to_json


		respond_to do |responder|
			responder.html { render 'show2.html' }
			responder.json { render json: @online_book_json_data  }
		end
	end



end
