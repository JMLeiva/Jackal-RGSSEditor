require 'fox16'	
include Fox  

#==============================================================================================
# ** JMLSearchStruct **
#==============================================================================================
class SearchStruct
	
	attr_reader :data_id
	attr_reader :position
	attr_reader :size
	attr_reader :sample_text
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Object Initialization
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def initialize(data_id, position, size, sample_text)
		@data_id = data_id
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
		#searchListener.call(searchResults[0].data_id, searchResults[0].positions[0], str.size)
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Prepare with data
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def prepare(dataList, str)
		@searchResults = []
		@str = str
		
		for data in dataList
			results = search_in_content(data, str)
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
			@table.setRowText(i, result.data_id) 
		end

		@table.setColumnText(0, "Result")
		
		@table.connect(SEL_DOUBLECLICKED, method(:on_item_selected) )
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Search str in data
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def search_in_content(data, str)
		results = []
		i = 0
		
		content = data[2]
		
		loop do
			i = content.index(str, i+1)
			
			if(i == nil)
				break
			end
			
			sampleStart = content.rindex("\n", i)
			sampleEnd = content.index("\n", i)
			
			sampleStr = content[sampleStart, sampleEnd - sampleStart]
						
			result = JMLSearchStruct.new(data[1], i, str.size, sampleStr)
			
			results.push(result)
		end
		
		return results
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# on_item_selected event
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def on_item_selected(sender, sel, ptr)
		result = @searchResults[ptr.row]
		@listener.call(result.data_id, result.position, @str.size)
	end
end