#!/usr/bin/ruby

require 'fox16'
require 'fox16/scintilla'
require_relative 'model\project'
require_relative 'widget\RGSSTabBook'
require_relative 'widget\SearchDialog'
require_relative 'widget\SearchAllResultsDialog'

#require 'clipboard'

include Fox  


RubyKeyWords = """__FILE__ and def end in or self unless __LINE__ 
        begin defined? ensure module redo super until BEGIN 
        break do false next rescue then when END case 
        else for nil retry true while alias class elsif 
        if not return undef yield"""	
#==============================================================================================
# ** RGSSScriptEditor **
# Script editor for RPGMaker XP, VX & VX Ace
# Author : Juan Martin Leiva [Metalero]
# Powered by :
#		ruby
#		FXRuby
#==============================================================================================
class ScriptEditor < FXMainWindow  
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Object Initialization
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def initialize(app, title, w, h)  
		super(app, title, :width => w, :height => h)  
		@project = nil
		@opened = false
		create_layout
	end
  
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# FX Crate & Show
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def create  
		super  
		show(PLACEMENT_SCREEN) 
		FXWindow.colorType = getApp().registerDragType(nil)		
		
		#a = Clipboard.paste
	end  
  
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Load Scripts File
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def load_data(path)
	    
		path_utf8  = path.encode("UTF-8")

    @project = Project.create(path_utf8)
		
		setup_list
		@save_cmd.enabled = true
		@save_all_cmd.enabled = true
		@save_button.enabled = true
		@save_all_button.enabled = true
		@close_cmd.enabled = true
		@search_cmd.enabled = true
		@search_all_cmd.enabled = true
		@eval_button.enabled = true
		
		if @project.has_valid_game_path?
			@play_button.enabled = true
		end
		
	end

	

	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Create Base Layout
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def create_layout	

		#MENU BAR
		
		#File
		menu_bar = FXMenuBar.new(self, LAYOUT_SIDE_TOP | LAYOUT_FILL_X)  
		file_menu = FXMenuPane.new(self)  
			 
		# OPEN
		@open_cmd = FXMenuCommand.new(file_menu, "Open")  
		@open_cmd.connect(SEL_COMMAND) do  
			start_open_dialog()
		end  
		
		@close_cmd = FXMenuCommand.new(file_menu, "Close")  
		@close_cmd.enabled = false
		@close_cmd.connect(SEL_COMMAND) do  
			close_project()
		end  
		
		# SAVE
		@save_cmd = FXMenuCommand.new(file_menu, "&Save\tCtl-S\tSave current file")  
		@save_cmd.enabled = false
		@save_cmd.connect(SEL_COMMAND) do  
			saveCurrentPage
		end  
		
		# SAVE ALL
		@save_all_cmd = FXMenuCommand.new(file_menu, "&Save All\tAlt-Ctl-S\tSave all opened files")  
		@save_all_cmd.enabled = false
		@save_all_cmd.connect(SEL_COMMAND) do  
			saveAllOpenPages
		end  
	  
		FXMenuSeparator.new(file_menu)  
		exit_cmd = FXMenuCommand.new(file_menu, "Exit")  
		exit_cmd.connect(SEL_COMMAND) do  
			exit  
		end  
	
		FXMenuTitle.new(menu_bar, "File", :popupMenu => file_menu)
		
		#SEARCH
		search_menu = FXMenuPane.new(self)  
		
		@searchDialog = SearchDialog.new(self, method(:onSearch))
		
		@search_cmd = FXMenuCommand.new(search_menu, "&Search...\tCtl-F\tSearch in this file")
		@search_cmd.enabled = false
		@search_cmd.connect(SEL_COMMAND) do  
			@searchDialog.show(PLACEMENT_SCREEN)
		end  
		
		FXMenuTitle.new(menu_bar, "Search", :popupMenu => search_menu)
		
		#SEARCH ALL
		
		@searchAllDialog = SearchDialog.new(self, method(:onSearchAll))
		@searchAllResults = SearchAllResults.new(self, method(:onSearchAllResult))
	
		@search_all_cmd = FXMenuCommand.new(search_menu, "&Search All...\tCtl-tAlt-F\tSearch in this file")  
		@search_all_cmd.enabled = false
		@search_all_cmd.connect(SEL_COMMAND) do  
			@searchAllDialog.show(PLACEMENT_SCREEN)
		end  
		
		#TOOLBAR
		main_frame = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
		toolbar_frame = FXHorizontalFrame.new(main_frame)
		
		icon = nil
		
		File.open("../res/SaveIcon.gif", "rb") do |f|
			icon = FXGIFIcon.new(getApp(), f.read)
		end
		@save_button = FXButton.new(toolbar_frame, "", icon)
		@save_button.enabled = false
		@save_button.connect(SEL_COMMAND) do  
			saveCurrentPage
		end  
		
		File.open("../res/SaveAllIcon.png", "rb") do |f|
			icon = FXPNGIcon.new(getApp(), f.read)
		end
		@save_all_button = FXButton.new(toolbar_frame, "", icon)
		@save_all_button.enabled = false
		@save_all_button.connect(SEL_COMMAND) do  
			saveAllOpenPages
		end  
		
		File.open("../res/PlayIcon.png", "rb") do |f|
			icon = FXPNGIcon.new(getApp(), f.read)
		end
		@play_button = FXButton.new(toolbar_frame, "", icon)
		@play_button.enabled = false
		@play_button.connect(SEL_COMMAND) do  
			play_release
		end  
		
		@eval_button = FXButton.new(toolbar_frame, "Eval", nil)
    @eval_button.enabled = false
    @eval_button.connect(SEL_COMMAND) do  
      eval_code
    end  
		
		#BODY
		horizontal_frame = FXHorizontalFrame.new(main_frame, :opts => LAYOUT_FILL)
		@list = FXList.new(horizontal_frame, nil, 0,  LAYOUT_FILL_Y|LAYOUT_FIX_WIDTH , 0,0, :width => 200)
		vertical_frame = FXVerticalFrame.new(horizontal_frame, :opts => LAYOUT_FILL)
		
		# Tabs
		@tabbook = RGSSTabBook.new(vertical_frame, nil, 0, LAYOUT_FILL|LAYOUT_RIGHT)
		@tabbook.willClosePageListener = method(:willClosePageListener)
		
		self.dropEnable
		# Handle SEL_DND_MOTION messages from the canvas
		self.connect(SEL_DND_ENTER) {
			# Accept drops unconditionally (for now)
			self.acceptDrop
		}
	end
	  
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Start Open Dialog
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def start_open_dialog
		dialog = FXFileDialog.new(self, "Open...")  
		dialog.selectMode = SELECTFILE_EXISTING  
		dialog.patternList = ["RMXP (Scripts.rxdata)", "RMVX (Scripts.rvdata)", "RMVXAce (Scripts.rvdata2)"]  
		if dialog.execute != 0  
			load_data(dialog.filename)  
		end  
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Close Project
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def close_project
		
		@tabbook.removeAllPages
		
		setup_list
		
		@save_cmd.enabled = false
		@save_all_cmd.enabled = false
		@save_button.enabled = false
		@save_all_button.enabled = false
		@play_button.enabled = false
		@search_all_cmd.enabled = false
		@search_cmd.enabled = false
		@close_cmd.enabled = false		
		@eval_button.enabled = false
		
		@project.close
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Setup Scripts List
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def setup_list
		@list.clearItems
		
		for script in @project.scripts
			@list.appendItem(script.name)
		end
		
		@list.connect(SEL_DOUBLECLICKED, method(:open_script) )
	end
	  
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Open Scritp to Edit
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def open_script(sender, sel, ptr)
		id = ptr

		script = @project.scripts[id]
		@tabbook.addPage(script)
	end  
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Script will be closed callback
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def willClosePageListener(page)
		if page.dirty
			result = FXMessageBox.warning(self, MBOX_YES_NO, "Unsaved script", "Save before close?")
			
			if result == MBOX_CLICKED_YES
				saveCurrentPage
			end	
		end
		
		return true
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Save current Script
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def saveCurrentPage
		@tabbook.writeCurrentContent
		@project.save
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Save current Script
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def saveAllOpenPages
		@tabbook.writeAllContents
		@project.save
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# On Search Callback
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def onSearch(str)
		if @tabbook.currentPage != nil
			@tabbook.currentPage.search(str)
		end
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# On Search Callback
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def onSearchAll(str)
		@searchAllResults.prepare(@project.scripts, str)
		@searchAllResults.show(PLACEMENT_SCREEN)
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# On Search Callback
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def onSearchAllResult(script, position, lenght)
		
		if(script == nil or position == nil)
			return
		end

		@tabbook.addPage(script)
		@tabbook.go_to(script.id, position, lenght)
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Save current Script
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def play_release
		system('"' + @gamePath + '"')
	end
	
	def eval_code
	  @project.eval
	end
end

########################
# Create FXApp and run
########################
def run
  	app = FXApp.new  
  
  	ScriptEditor.new(app, "Jackal - RGSS ScriptEditor", 1024, 768)  
  	app.create  
  	app.run  
end