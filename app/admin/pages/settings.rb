ActiveAdmin.register_page "Settings Page" do

  sidebar :help do
    ul do
      li "First Line of Help"
    end
  end

  content do
  	table do
	  tr do
  		td "Digital Archive Root"
  		td APP_SETTINGS['digital_archive_root']
  	  end
	  tr do
  		td "Digital Archive Derivative Root"
  		td APP_SETTINGS['digital_archive_derivative_root']
  	  end
  	end

  end
end
