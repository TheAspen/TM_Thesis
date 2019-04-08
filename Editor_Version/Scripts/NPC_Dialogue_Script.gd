extends Node2D

var Mission_Name = "default"
var Mission_Owner = null
var Mission_Experience = 0
var Mission_Is_Story = false
var Mission_Story_Index = 0

var NPC_Dialog = null
var Player_Main = null
var Player_Main_Dialog = null
var Player_Bonus = null
var Player_Bonus_Dialog = null

var Personal_Dialog_State = null
var Dialog_State = null

func _ready():
	#Might need own NPC global or something
	
	Dialog_State = "Personal"
	#_load_Mission_fromSave()
	
	pass

#Load mission dialogues from save file.
func _load_Mission_fromSave():
	var loaded_file = File.new()
	if(!loaded_file.file_exists(get_tree().get_root().get_node("Base_BaseNode").save_Path + "Global_Mission.txt")):
		print("No save file!")
		return
	loaded_file.open(get_tree().get_root().get_node("Base_BaseNode").save_Path + "Global_Mission.txt", File.READ)
	var current_line = parse_json(loaded_file.get_line())
	#print(current_line)
	if(current_line != null):
		for i in current_line.keys():
			print("map name ", Mission_Name)
			if( i == Mission_Name):
				Global_MissionDataScript.Missions[Mission_Name] = current_line[i]
				pass
		#print("dialog " , current_line)
	pass

#Load dialogues files from folder.
#Called from "dummy"-class.
func _load_Dialogue(path):
	var file = File.new()
	file.open(path, file.READ)
	var content = file.get_as_text()
	file.close()
	return content
	pass

#Initialize mission data.
#Called from "Dummy"-class.
func _init_Mission_Data(_name,_owner,experience,isStory,StoryIdx):
	Mission_Name = _name
	Mission_Owner = _owner
	Mission_Experience = experience
	Mission_Is_Story = isStory
	Mission_Story_Index = StoryIdx
	_load_Mission_fromSave()
	Dialog_State = Global_MissionDataScript.Missions[Mission_Name]
	
	pass
func _start_Mission():
	self.add_to_group("Save_Mission")
	get_parent().get_child(0)._load_Mission_Dialogues()
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode/PlayerHUD_BaseNode").Player_Dialogue_Scene._add_Quest_toPlayer(Mission_Name)
	pass
func _setup_Dialog(ID,dictionary):
	if(ID == "NPC"):
		NPC_Dialog = dictionary
	if(ID == "Player"):
		 Player_Main = dictionary
	if(ID == "Bonus"):
		Player_Bonus = dictionary
	pass
	
	
	pass
func _set_pause(pause):
	if(get_tree().paused == pause):
		return
	
	get_tree().paused = pause
	
	pass
func _update_Dialog():
	_set_pause(true)
	_clear_Dialogue()
	_add_NPC_Mission_Text(Dialog_State)
	_check_Answer(Dialog_State)
	_check_Optional_Answer(Dialog_State)
	pass
func _check_Optional_Answer(currentState):
	
	if(Player_Bonus == null):
		return
	#Check player variables
	#Check are optionals available
	
	if(Player_Bonus.has(currentState)):
		_add_Optional_Answer(Player_Bonus[currentState])
		Player_Bonus_Dialog = Player_Bonus[currentState]
		pass
	pass
func _check_Answer(currentState):
	
	if(Player_Main.has(currentState)):
		_add_Answer(Player_Main[currentState])
		Player_Main_Dialog = Player_Main[currentState]
	pass

func _add_Answer(dictionary):
	var dialogKeys = dictionary.keys()
	for i in range(dialogKeys.size()):
		get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode/PlayerHUD_BaseNode").Player_Dialogue_Scene._init_Player_Text(dictionary[dialogKeys[i]])
	
	pass

func _add_NPC_Mission_Text(currentState):
	print("Current State ", currentState)
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode/PlayerHUD_BaseNode").Player_Dialogue_Scene._init_NPC_Text(NPC_Dialog[currentState])
	
	pass
func _add_Optional_Answer(dictionary):
	var dialogKeys = dictionary.keys()
	for i in range(dialogKeys.size()):
		get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode/PlayerHUD_BaseNode").Player_Dialogue_Scene._init_Player_Text(dictionary[dialogKeys[i]])
	
	pass
func _process_Player_Answer(text):
	var answerID = null
	if(Player_Bonus != null && Player_Bonus.has(Dialog_State)):
		var dialogKeys_Bonus = Player_Bonus_Dialog.keys()
		for i in range(dialogKeys_Bonus.size()):
			if(text == Player_Bonus_Dialog[dialogKeys_Bonus[i]]):
				answerID = dialogKeys_Bonus[i]
				break
				
	if(answerID == null):
		var dialogKeys = Player_Main_Dialog.keys()
		for i in range(dialogKeys.size()):
				if(text == Player_Main_Dialog[dialogKeys[i]]):
					answerID = dialogKeys[i]
					break
	
	match answerID:
		"Start Mission":
			_start_Mission()
			_update_Dialog()
			pass
		"State 1":
			Dialog_State = "State 1"
			_update_Dialog()
			_process_NPC()
			pass
		"Pass":
			Dialog_State = "Pass"
			_update_Dialog()
			_send_Data_toGlobal()
			_process_NPC()
			pass
		"Failed":
			Dialog_State = "Failed"
			_update_Dialog()
			_send_Data_toGlobal()
			_process_NPC()
			pass
		"Complete":
			Dialog_State = "Complete"
			_update_Dialog()
			_send_Data_toGlobal()
			_process_NPC()
			pass
		"Quit":
			_end_Dialogue()
			_set_toDefaults()
			pass
		null:
			print("Something went wrong in _process_Player_Answer in node: " , self)
	
	print(answerID)
	pass

func _process_NPC():
	Mission_Owner._update_NPC_Behavior()
	
	pass
#Save this!!!
func _send_Data_toGlobal():
	Global_MissionDataScript.Missions[Mission_Name] = Dialog_State
	print(Global_MissionDataScript.Missions[Mission_Name])
	pass
func _Save_Data():
	var save_file = {
		Mission_Name : Global_MissionDataScript.Missions[Mission_Name]}
	print("Dialog save file: " , save_file)
	return save_file
	pass
func _set_toDefaults():
	get_parent().get_child(0)._load_Personal_Dialogues()
	Dialog_State = "Personal"
	pass
func _end_Dialogue():
	_set_pause(false)
	_clear_Dialogue()
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode/PlayerHUD_BaseNode").Player_Dialogue_Scene._end_Player_Dialogue()
	pass
func _clear_Dialogue():
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode/PlayerHUD_BaseNode").Player_Dialogue_Scene._clear_Player_Answers()
	pass
	