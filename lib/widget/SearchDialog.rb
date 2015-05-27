require 'fox16'	
include Fox  

###############################################################################################
# SearchDialog
###############################################################################################
class SearchDialog < FXDialogBox

	def initialize(owner, searchListener)
		# Invoke base class initialize function first
		super(owner, "Search", DECOR_TITLE|DECOR_CLOSE|DECOR_RESIZE, :width => 260, :height => 100  )

		

		# Contents
		contents = FXVerticalFrame.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y)

		#Search Field
		searchField = FXTextField.new(contents, 1, :opts => TEXTFIELD_NORMAL|LAYOUT_FILL_X)
	   
		searchField.connect(Fox::SEL_KEYPRESS){|a,b,event| 
			if KEY_Return == event.code
				searchListener.call(searchField.text)
			end

			false
		}
	   
		# Search
		search = FXButton.new(contents, "&Search", nil, self, ID_ACCEPT, FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)
		search.connect(SEL_COMMAND) do  
			searchListener.call(searchField.text)
		end  	
		
		
		
		searchField.setDefault
		searchField.setFocus
		
		
	end
end
