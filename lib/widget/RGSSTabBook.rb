require 'fox16'	
include Fox  

###############################################################################################
# RGSSPage
###############################################################################################
class RGSSPage
	attr_reader :script
	attr_reader :dirty
	
	attr_reader	:tab
	attr_reader	:scint
	
	def initialize(script, tab, scint)
		@script = script
		@dirty = false
		
		@tab = tab
		@scint = scint
		
		@scint.setTargetStart(0)
		@scint.setTargetEnd(@scint.getTextLength - 1)
		
		@scint.setSearchFlags(0)
	end
	
	def dirty=(dirty)
		@tab.dirty = dirty
		@dirty = dirty
	end
	
	def writeCurrent()
		@script.content = @scint.getText(@scint.getTextLength)
	end
	
	def search(str)
		
		@scint.setTargetStart(@lastSearch)
		@scint.setTargetEnd(@scint.getTextLength - 1)
		
		@lastSearch = @scint.searchInTarget(str.size, str)
		@scint.searchAnchor
		
		if @lastSearch != -1
			@scint.setSelection(@lastSearch, @lastSearch + str.size)
			@lastSearch += 1
			@scint.scrollCaret
		else
			@lastSearch = 0
		end		
	end
	
	def gotoAndSelect(pos, lenght)
		safePosition = getBeginingOfPreviousLine(pos, 2)
		@scint.gotoPos(safePosition)
		@scint.setSelection(pos, pos+lenght)
	end
	
	def getBeginingOfPreviousLine(pos, previousLine = 0)
		lineBreaks = 0
		
		pos.downto(0){|previousPos|
			
			if @content[previousPos] == "\n"
				lineBreaks += 1
			end
			
			if lineBreaks > previousLine
				return previousPos+1
			end
		}
		
		return pos
	end
end

###############################################################################################
# ClosableItem
# TabItem with a close button
###############################################################################################
class ClosableTabItem < FXHorizontalFrame
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Initialize
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def initialize(p, text, width) 
		super(p, TAB_TOP_NORMAL, 0, 0, width, 24, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD, DEFAULT_PAD)
		@textLabel = FXButton.new(self, text, nil, nil, 0, 0)
		
		@textLabel.connect(SEL_COMMAND) do  
			tabBar = self.getParent()
			index = tabBar.indexOfChild(self)
			tabBar.setCurrent(index/2)
		end  
		
		closeButton = FXButton.new(self, "x", nil, nil, 0, 0)
		closeButton.connect(SEL_COMMAND) do  
			tabBar = self.getParent()
			
			index = tabBar.indexOfChild(self) / 2
			tabBar.removePage(index)
		end  
		
		@name = text
	end 
	
	def dirty=(dirty)
		if dirty
			@textLabel.text = @name + "*"
		else
			@textLabel.text = @name
		end
	end
end

###############################################################################################
# RGSSTabBook
###############################################################################################	
BackgroundColor = 	FXRGB(0x00, 0x00, 0x00)
CommentColor =		FXRGB(0x00, 0xAf, 0x00) 
NumberColor = 		FXRGB(0x60, 0xDF, 0xEF)
KeyWordColor = 		FXRGB(0x20, 0xA0, 0xF0)
StringColor = 		FXRGB(0x60, 0xDF, 0xEF) 
CharacterColor = 	FXRGB(0x60, 0xDF, 0xEF)
ClassNameColor = 	FXRGB(0x1A, 0x40, 0xF0)
DefNameColor = 		FXRGB(0xD0, 0xB0, 0xA0)
OperatorColor = 		FXRGB(0x60, 0xDF, 0xEF)
IdentifierColor = 		FXRGB(0xD0, 0xB0, 0xA0)
RegexColor = 		FXRGB(0xFF, 0x00, 0XFF)
GlobalColor	= 		FXRGB(0xFF, 0xFF, 0XFF)
SymbolColor = 		FXRGB(0x60, 0xDF, 0xEF)
ModuleNameColor =	FXRGB(0x1A, 0x40, 0xF0)
InstanceVarColor = 	FXRGB(0x1A, 0x40, 0xF0)
ClassVarColor =		FXRGB(0xFF, 0xFF, 0XFF)
BacksticksColor = 	FXRGB(0xFF, 0xFF, 0XFF)
StringQQColor = 		FXRGB(0xFF, 0xFF, 0XFF)
CaretColor	=		FXRGB(0xFF, 0xFF, 0XFF)
SelectionForeground =  FXRGB(0xFF, 0xFF, 0XFF)


class RGSSTabBook < FXTabBook
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Object Initialization
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def initialize(p, target = nil, selector = 0, opts = 0, x = 0, y = 0, width = 0, height = 0)
		super
		
		@pages = []
		@willClosePageListener = nil
		
		
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# "On Will Close" callback setter
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def willClosePageListener=(willClosePageListener)
		@willClosePageListener = willClosePageListener
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Add Page
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def addPage(script)
		
		#Check if already opened
		for i in 0...@pages.size
			if @pages[i].script.id == script.id
				self.setCurrent(i)
				return
			end
		end
		
		
		
		
		tab = ClosableTabItem.new(self, script.name, 100)
		
		
		scint = FXScintilla.new(self, nil, 0, :opts => TEXT_WORDWRAP|LAYOUT_FILL)  
		scint.setLexerLanguage("ruby")
		scint.setKeyWords(0, RubyKeyWords)
		scint.styleSetFont(FXScintilla::STYLE_DEFAULT, "fixed")
		scint.styleSetSize(FXScintilla::STYLE_DEFAULT, 12)
		scint.styleClearAll

		#General Background
		scint.styleSetBack(32, BackgroundColor)
	
		#WhiteSpaces
		scint.styleSetBack(FXScintilla::SCE_P_DEFAULT, BackgroundColor)
		
		# Comment
		scint.styleSetFore(2, CommentColor)
		scint.styleSetBack(2, BackgroundColor)
		
		# POD ??
		#scint.styleSetFore(3, CommentColor)
		#scint.styleSetBack(3, BackgroundColor)
		
		#Numbers
		scint.styleSetFore(4, NumberColor)
		scint.styleSetBack(4, BackgroundColor)
		
		#KeyWord
		scint.styleSetFore(5, KeyWordColor)
		scint.styleSetBack(5, BackgroundColor)
		
		#String
		scint.styleSetFore(6, StringColor)
		scint.styleSetBack(6, BackgroundColor)
		
		#Character
		scint.styleSetFore(7, CharacterColor)
		scint.styleSetBack(7, BackgroundColor)
		
		#ClassName
		scint.styleSetFore(8, ClassNameColor)
		scint.styleSetBack(8, BackgroundColor)
		
		#DefName
		scint.styleSetFore(9, DefNameColor)
		scint.styleSetBack(9, BackgroundColor)
		
		#Operator
		scint.styleSetFore(10, OperatorColor)
		scint.styleSetBack(10, BackgroundColor)
		
		#Identifier
		scint.styleSetFore(11, IdentifierColor)
		scint.styleSetBack(11, BackgroundColor)
		#scint.styleSetHotSpot(11, true)
		
		#Regex
		scint.styleSetFore(12, RegexColor)
		scint.styleSetBack(12, BackgroundColor)
		
		#Global
		scint.styleSetFore(13, GlobalColor)
		scint.styleSetBack(13, BackgroundColor)
		
		#Symbol
		scint.styleSetFore(14, SymbolColor)
		scint.styleSetBack(14, BackgroundColor)
		
		#ModuleName
		scint.styleSetFore(15, ModuleNameColor)
		scint.styleSetBack(15, BackgroundColor)
		
		#InstanceVar
		scint.styleSetFore(16, InstanceVarColor)
		scint.styleSetBack(16, BackgroundColor)
		
		#ClassVar
		scint.styleSetFore(17, ClassVarColor)
		scint.styleSetBack(17, BackgroundColor)
		
		#Backsticks (` `)
		scint.styleSetFore(18, BacksticksColor)
		scint.styleSetBack(18, BackgroundColor)
		
		#DataSection??
		scint.styleSetFore(19, CommentColor)
		scint.styleSetBack(19, CommentColor)
		
		#HereDelim??
		scint.styleSetFore(20, CommentColor)
		scint.styleSetBack(20, CommentColor)
		
		#HereQ??
		scint.styleSetFore(21, CommentColor)
		scint.styleSetBack(21, CommentColor)
		
		#HereQQ??
		scint.styleSetFore(22, CommentColor)
		scint.styleSetBack(22, CommentColor)

		#HereQX??
		scint.styleSetFore(23, CommentColor)
		scint.styleSetBack(23, CommentColor)
		
		#StringQ??
		scint.styleSetFore(24, CommentColor)
		scint.styleSetBack(24, CommentColor)
		
		#StringQQ => %=
		scint.styleSetFore(25, StringQQColor)
		scint.styleSetBack(25, BackgroundColor)
		
		#StringQX??
		scint.styleSetFore(26, CommentColor)
		scint.styleSetBack(26, CommentColor)
		
		#StringQR??
		scint.styleSetFore(27, CommentColor)
		scint.styleSetBack(27, CommentColor)
		
		#StringQW??
		scint.styleSetFore(28, CommentColor)
		scint.styleSetBack(28, CommentColor)
		
		#Caret (Cursor)
		scint.setCaretFore(CaretColor)
		
		#Selection
		scint.setSelFore(true, SelectionForeground)
		
		scint.setMarginWidthN(0, 48)
		
		#--------------------------------------------------------------------------------
		scint.styleSetEOLFilled(FXScintilla::SCE_P_STRINGEOL, true)
		
		scint.styleSetFore(34, FXRGB(0x00, 0x00, 0xff) & 0xffffff)
		scint.styleSetBold(34, true)
		scint.styleSetFore(35, FXRGB(0xff, 0x00, 0x00) & 0xffffff)
		scint.styleSetBold(35, true)
		
		scint.insertText(0, script.contents)
		
		#Auto Complete Setup?
		#scint.autoCSetAutoHide(true)
		#scint.autoCSetCancelAtStart(false)
		#scint.autoCSetChooseSingle(false)
		#scint.autoCSetDropRestOfWord(true)
		#scint.autoCSetFillUps("a") #???
		#scint.autoCSetIgnoreCase(true)
		#scint.autoCSetMaxHeight(10)
		#scint.autoCSetMaxWidth(50)
		#scint.autoCSetSeparator(' ')
		#scint.autoCSetTypeSeparator('?')
		#scint.autoCStops(";")
		#scint.registerImage
		#scint.registerRGBAImage
		
		
		
		#Events
		scint.connect(SEL_CHANGED,  method(:onTextChanged) )
		
		scint.connect(SEL_COMMAND) do |sender, sel, ptr|
			
			if  ptr.nmhdr.code == FXScintilla::SCN_CHARADDED
				#p "--------------"
				#p "CH: " + ptr.ch.to_s
				#p "Fold LV Now: " + ptr.foldLevelNow.to_s
				#p "Fold LV Prev: " + ptr.foldLevelPrev.to_s
				#p "Leght: " +  ptr.length.to_s
				#p "Line: " + ptr.line.to_s
				#p "Lines Added: " + ptr.linesAdded.to_s
				#p "List Type: " + ptr.listType.to_s
				#p "LParam: " + ptr.lParam.to_s
				#p "Margin: " + ptr.margin.to_s
				#p "Message: " + ptr.message.to_s
				#p "Modification Type: " + ptr.modificationType.to_s
				#p "Modifiers: " + ptr.modifiers.to_s
				#p "NMHDR idFrom: " + ptr.nmhdr.idFrom.to_s
				#p "NMHDR code: " + ptr.nmhdr.code.to_s
				#p "Text: " + ptr.text.to_s
				#p "WParam: " + ptr.wParam.to_s
				#p "X: " + ptr.x.to_s
				#p "Y: " + ptr.y.to_s
				#p "--------------"

				scint.autoCShow(2, "end start")
			end
		end
		
		
		self.setCurrent(@pages.size)
		self.create # realize widgets
		self.recalc # mark parent layout dirty
		
		page = RGSSPage.new(script, tab, scint)
		@pages.push(page)
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# On Text Changed Callback
	# Sets page as dirty
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def onTextChanged(sender, sel, ptr)
		index = self.indexOfChild(sender)-1
		page = @pages[index/2]
		page.dirty = true
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Remove page from the tab book
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def removePage(index)
		
		page = @pages[index]
		
		if @willClosePageListener != nil
			if !@willClosePageListener.call(page)
				return
			end
		end
		
		
		self.removeChild(page.scint)
		self.removeChild(page.tab)
		
		@pages.delete_at(index)
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Remove all pages
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def removeAllPages
		while @pages.size > 0
			removePage(0)
		end
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Return current opened page
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def currentPage
		if @pages.size == 0
			return
		end
		
		index = self.current
		return @pages[index]
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Return an array of all opened pages
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def openPages
		return @pages
	end

	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	#  Write Content of  selected page
	# Transfers text edited, to the model
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def writeCurrentContent
		if @pages.size == 0
			return
		end
		
		index = self.current
		page = @pages[index]
		page.writeCurrent
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Write Content of all pages.
	# Transfers text edited, to the model
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def writeAllContents
		for page in @pages
			page.writeCurrent
		end
	end
	
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	# Go to position
	#-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	def go_to(page_id, position, lenght)
		for i in 0...@pages.size
			if @pages[i].id == page_id
				self.setCurrent(i)
				
				@pages[i].gotoAndSelect(position, lenght)
				return
			end
		end
	end
end