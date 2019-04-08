extends Node


var SaveSlotIndex = null
var SaveSlot0_Path = null
var SaveSlot1_Path = null
var SaveSlot2_Path = null
var SaveSlot3_Path = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#get_node("Background").rect_size = get_viewport().size
	#Check is there any save files in saveslots folder.
	#If there is load them to the rigt save slot
	#HOX: save slot only contains Name and Path
	var data = null
	var file = File.new()
	for i in range(4):
		if(file.file_exists("res://SaveSlots/SaveSlot" + str(i) + ".slot")):
			match i:
				0:
					data = _Read_SaveSlotData(i)
					SaveSlot0_Path = data["Path"]
					_set_SaveSlotName(i,data["Name"])
				1:
					data = _Read_SaveSlotData(i)
					SaveSlot1_Path = data["Path"]
					_set_SaveSlotName(i,data["Name"])
				2:
					data = _Read_SaveSlotData(i)
					SaveSlot2_Path = data["Path"]
					_set_SaveSlotName(i,data["Name"])
				3:
					data = _Read_SaveSlotData(i)
					SaveSlot3_Path = data["Path"]
					_set_SaveSlotName(i,data["Name"])
			pass
		
	get_node("Background/SaveSlotMenu").hide()
	get_node("Background/SaveSlotMenu/NamePanel").hide()
	pass

func _set_SaveSlotName(index,slotName):
	get_node("Background/SaveSlotMenu/SaveSlots").set_item_text(index,slotName)
	pass
	
func _input(event):
	if( SaveSlotIndex != null && event is InputEventMouseButton && event.doubleclick):
		_use_SaveSlot()
		pass
	pass
func _reset_Variables():
	get_node("Background/SaveSlotMenu/NamePanel/TextEditor").clear()
	SaveSlotIndex = null
	get_node("Background/SaveSlotMenu/NamePanel").hide()
	get_node("Background/SaveSlotMenu").hide()
	pass
#If save slot name is different than "Empty", then there should be some save file.
#Then start the game with the save slot path
func _use_SaveSlot():
	if(get_node("Background/SaveSlotMenu/SaveSlots").get_item_text(SaveSlotIndex) != "Empty"):
		print("Slot has a name",get_node("Background/SaveSlotMenu/SaveSlots").get_item_text(SaveSlotIndex)  )
		match SaveSlotIndex:
			0:
				_start_Game(SaveSlot0_Path)
			1:
				_start_Game(SaveSlot1_Path)
			2:
				_start_Game(SaveSlot2_Path)
			3:
				_start_Game(SaveSlot3_Path)
		return
		
	get_node("Background/SaveSlotMenu/NamePanel").show()
	pass


func _on_PlayButton_pressed():
	get_node("Background/SaveSlotMenu").show()
	pass 


func _on_ExitButton_pressed():
	get_tree().quit()
	pass # replace with function body


func _on_OptionsButton_pressed():
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").UI_ChangeCurrentState("OptionsState")
	pass # replace with function body


func _on_SaveSlots_item_selected(index):
	
	SaveSlotIndex = index
	pass # replace with function body
# replace with function body

#Ask names for the save slot and saves them to the save slots folder.
func _on_ContinueButton_pressed():
	var default = "Name is Invalid!"
	var slotName = get_node("Background/SaveSlotMenu/NamePanel/TextEditor")
	if(slotName.text.length() < 3 || slotName.text == default):
		get_node("Background/SaveSlotMenu/NamePanel/TextEditor").text = default
		return
	
	get_node("Background/SaveSlotMenu/SaveSlots").set_item_text(SaveSlotIndex, slotName.text)
	get_tree().get_root().get_node("Base_BaseNode")._create_Save_Dir(slotName.text)
	print("save slot index ", SaveSlotIndex) 
	match SaveSlotIndex:
		0:
			SaveSlot0_Path = "res://Scenes/Saved/" + slotName.text + "/"
			get_tree().get_root().get_node("Base_BaseNode").save_Path = SaveSlot0_Path
			_Save_SaveSlotPath(SaveSlot0_Path,0,slotName.text)
		1:
			SaveSlot1_Path = "res://Scenes/Saved/" + slotName.text + "/"
			get_tree().get_root().get_node("Base_BaseNode").save_Path = SaveSlot1_Path
			_Save_SaveSlotPath(SaveSlot1_Path,1, slotName.text)
		2:
			SaveSlot2_Path = "res://Scenes/Saved/" + slotName.text + "/"
			get_tree().get_root().get_node("Base_BaseNode").save_Path = SaveSlot2_Path
			_Save_SaveSlotPath(SaveSlot2_Path,2, slotName.text)
		3:
			SaveSlot3_Path = "res://Scenes/Saved/" + slotName.text + "/"
			get_tree().get_root().get_node("Base_BaseNode").save_Path = SaveSlot3_Path
			_Save_SaveSlotPath(SaveSlot3_Path,3,  slotName.text)
	pass
	_start_Game(null)
	pass # replace with function body

func _Save_SaveSlotPath(slotPath, index, slotName):
	var file = File.new()
	if(file.open("res://SaveSlots/SaveSlot" + str(index) + ".slot", File.WRITE) != 0):
		print("Error in writing SAVE SLOT PATH to SAVE SLOT TEXT FILE!")
	var dict = {"Name":slotName,"Path":slotPath}
	file.store_line(to_json(dict))
	file.close()
	pass

func _Read_SaveSlotData(index):
	var file = File.new()
	if(!file.file_exists("res://SaveSlots/SaveSlot" + str(index) + ".slot")):
		print("Error, save file not exists!")
		return null
	
	if(file.open("res://SaveSlots/SaveSlot" + str(index) + ".slot", File.READ) != 0):
		print("Error in reading SAVE SLOT PATH from SAVE SLOT TEXT FILE!")
		return
	var data = parse_json(file.get_line())
	file.close()
	return data

func _start_Game(loadPath):
	_reset_Variables()
	if(loadPath != null):
		get_tree().get_root().get_node("Base_BaseNode").save_Path = loadPath
		get_tree().get_root().get_node("Base_BaseNode")._load_Player(loadPath)
		pass
	#Start game
	get_tree().get_root().get_node("Base_BaseNode").Base_ChangeCurrentState("GameState")
	#get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").UI_ChangeCurrentState("PlayerHudState")
	pass

func _on_BackButton_pressed():
	get_node("Background/SaveSlotMenu/NamePanel/TextEditor").clear()
	SaveSlotIndex = null
	get_node("Background/SaveSlotMenu/NamePanel").hide()
	pass # replace with function body

func _on_DeleteButton_pressed():
	if(SaveSlotIndex == null):
		return
	
	var dir = Directory.new()
	#print("path: " , str(get_node("Background/SaveSlotMenu/SaveSlots").get_item_text(SaveSlotIndex)))
	dir.remove("res://Scenes/Saved/" + str(get_node("Background/SaveSlotMenu/SaveSlots").get_item_text(SaveSlotIndex)))
	dir.remove("res://SaveSlots/SaveSlot" + str(SaveSlotIndex) + ".slot")
	get_node("Background/SaveSlotMenu/SaveSlots").set_item_text(SaveSlotIndex, "Empty")
	pass # replace with function body

func _on_LoadButton_pressed():
	if( SaveSlotIndex != null):
		_use_SaveSlot()
		pass
	pass # replace with function body


func _on_BackButton_SaveSlot_pressed():
	get_node("Background/SaveSlotMenu").hide()
	SaveSlotIndex = null
	pass # replace with function body
