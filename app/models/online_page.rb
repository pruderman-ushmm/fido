class OnlinePage < ActiveRecord::Base
	belongs_to :online_book
	belongs_to :digital_asset
end
