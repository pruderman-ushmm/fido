class OnlineBooksController < ApplicationController

	def index
		@online_books = OnlineBook.all
	end

	def show
		@online_book = OnlineBook.find_by_designation(params[:designation])
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

		@online_book_json_data = @pages_hash.to_json

		@user_ip = request.remote_ip  ## does this work under apache?
		puts "RRR: ";
		require "awesome_print"
		pp request;
		x = { :a => 1, :b => "a string", :c => [1,2,[3,4]], :d => Time.now  }
		ap x


		respond_to do |responder|
			responder.html { render 'show2.html' }
			responder.json { render json: @online_book_json_data  }
		end
	end
################################################################
	def show_thumbnails
		@online_book = OnlineBook.find_by_designation(params[:designation])
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
		@online_pages_hash = {};
		unsorted_pages_array.each { |i|
			@online_pages_hash[i[:id]] = i
		}

		# Sort the array (which is keyed by id) according to page designation:
		@online_pages_seq_array = unsorted_pages_array.map { |a| a[:id] }.sort { |b,c| @online_pages_hash[b][:designation].to_i <=> @online_pages_hash[c][:designation].to_i }

		@online_pages_hash_json = @online_pages_hash.to_json

		@user_ip = request.remote_ip  ## for populating feedback form

		respond_to do |responder|
			responder.html { render 'show_thumbnails.html' }
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
	end

	def show_page
		lookup_page params[:designation], params[:page_designation]

		respond_to do |responder|
			responder.html { render 'show_page.html' }
			# responder.json { render json: @online_book_json_data  }
		end
	end

	def zoom_page
		lookup_page params[:designation], params[:page_designation]

		respond_to do |responder|
			responder.html { render 'zoom_page.html' }
			# responder.json { render json: @online_book_json_data  }
		end
	end


end
