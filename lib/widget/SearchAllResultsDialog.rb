require 'fox16'	
include Fox  

#==============================================================================================
# ** JMLSearchStruct **
#==============================================================================================
class SearchStruct
	
	attr_reader :script
	attr_reader :position
	attr_reader :size
	attr_reader :sample_text
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Object Initialization
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def initialize(script, position, size, sample_text)
		@script = script
		@position = position
		@size = size
		@sample_text = sample_text
	end
end

#==============================================================================================
# ** JMLSearchAllResults **
#==============================================================================================
class SearchAllResults < FXDialogBox
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Object Initialization
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def initialize(owner, searchListener)
		
		super(owner, "Search All", DECOR_TITLE|DECOR_BORDER|DECOR_CLOSE, :width => 460, :height => 400  )
		
		# Contents
		#@list = FXList.new(self, nil, 0,  LAYOUT_FILL_Y|LAYOUT_FILL_X , 0,0)
		@table = FXTable.new(self,
		:opts => TABLE_COL_SIZABLE|TABLE_ROW_SIZABLE|LAYOUT_FILL_X|LAYOUT_FILL_Y|TABLE_NO_COLSELECT|TABLE_NO_ROWSELECT|TABLE_READONLY ,
		:padding => 2)

		@table.visibleRows = 10
		@table.visibleColumns = 1
		
		@table.defRowHeight = 64
		@table.defColumnWidth = 320

		@listener = searchListener
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Prepare with scripts
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def prepare(scripts, str)
		@searchResults = []
		@str = str
		
		for script in scripts
			results = search_in_content(script, str)
			@searchResults.concat(results)
		end		
		
		

		@table.setTableSize(@searchResults.size, 1)

		@table.setBackColor(FXRGB(255, 255, 255))
		@table.setCellColor(0, 0, FXRGB(255, 255, 255))
		@table.setCellColor(0, 1, FXRGB(255, 240, 240))
		@table.setCellColor(1, 0, FXRGB(240, 255, 240))
		@table.setCellColor(1, 1, FXRGB(240, 240, 255))
		
		
		
		for i in 0...@searchResults.size
			result = @searchResults[i]
			@table.setItemText(i, 0, result.sample_text)
			@table.setRowText(i, result.script.name) 
		end

		@table.setColumnText(0, "Result")
		
		@table.connect(SEL_DOUBLECLICKED, method(:on_item_selected) )
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Search str in script
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def search_in_content(script, str)
		results = []
		i = 0
		
		content = script.contents
		
		loop do
			i = content.index(str, i+1)
			
			if(i == nil)
				break
			end
			
			sampleStart = content.rindex("\n", i)
			sampleEnd = content.index("\n", i)
			
			sampleStr = content[sampleStart, sampleEnd - sampleStart]
						
			result = SearchStruct.new(script, i, str.size, sampleStr)
			
			results.push(result)
		end
		
		return results
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# on_item_selected event
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def on_item_selected(sender, sel, ptr)
		result = @searchResults[ptr.row]
		@listener.call(result.script, result.position, @str.size)
	end
end