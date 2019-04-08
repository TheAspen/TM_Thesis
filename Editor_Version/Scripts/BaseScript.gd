extends Node

onready var Player_Scene = preload ("res://Scenes/PlayerScene.tscn").instance()
onready var UI_Scene = preload ("res://Scenes/UIScene.tscn").instance()
onready var Map_Scene = preload ("res://Scenes/Map1_Scene.tscn").instance()


var defaultPlayer = 0;
var defaultUI = 0;
var defaultMap = 0;
var slotName = "default"
var save_Path = "res://Scenes/"

var Menu_State = "MenuState"
var Game_State = "GameState"
var default_State = "defaultState"
var Current_State = 0

func _ready():
	Current_State = Menu_State
	add_child(UI_Scene)
	Base_ProcessState()
	#In start of each Scene set default values in _ready(). Like default map in MapScene is map 1. 
	#And in PlayerScene, default player is Starting character level 0.
	pass

#Load default scenes:
func Base_LoadDefaultScenes():
	Player_Scene = preload ("res://Scenes/PlayerScene.tscn").instance()
	Map_Scene = preload ("res://Scenes/Map1_Scene.tscn").instance()
	pass

#Base re-initialization, delete current map and player scnes.
#Load default scenes.
#Set pause to false and change scene to main menu state.
#Basic use case is then player is quiting the game.
func Base_ReInit():
	Map_Scene.queue_free()
	Player_Scene.queue_free()
	Base_LoadDefaultScenes()
	get_tree().paused = false
	Base_ChangeCurrentState(Menu_State)
	
#Base state switcher:
func Base_ChangeCurrentState(new_State):
	Current_State = new_State
	Base_ProcessState()
	pass

#Base state machine:
func Base_ProcessState():
	
	match Current_State:
		"MenuState":
			UI_Scene.UI_ChangeCurrentState("MainMenu_State")
			print("CurrentState is " + Current_State)
			
		"GameState":
			#Have to down UIScene, cause it has to be drawn at the last?
			print("GAmestate ",Map_Scene.MapName)
			UI_Scene.UI_ChangeCurrentState("PlayerHudState")
			add_child(Player_Scene)
			add_child(Map_Scene)
			UI_Scene.call_deferred("raise")
			print("CurrentState is " + Current_State)
			
		"defaultState":
			print("CurrentState is " + Current_State)
			
	pass

#Change map scene.
#Search save direction for map scene.
#If map is found, use save direction path to load that map. (Map has been saved before!)
#If not, use default map. (Map is new and have NOT been saved before.)
func _change_Map_Scene(new_Map,spawnPoint):
	var map = null
	var dir = Directory.new()
	print("Search this map path : " ,save_Path + new_Map)
	if(dir.file_exists(save_Path + new_Map + "_Scene.tscn")):
		map = load(save_Path + new_Map + "_Scene.tscn")
		print("File " , new_Map , " found!")  
		pass
	else:
		map = load("res://Scenes/" + new_Map + "_Scene.tscn")
		print("File " , new_Map , " NOT found!")  
		pass
	Map_Scene.queue_free()
	Map_Scene = map.instance()
	add_child(Map_Scene)
	Player_Scene.position = Map_Scene.get_node(spawnPoint).position
	_save_Game()
	pass
	
#Create save direction when game is created.
#If there is same named folder, this function will return!
func _create_Save_Dir(saveName):
	var dir = Directory.new()
	dir.open("res://Scenes/Saved/")
	if(dir.dir_exists("res://Scenes/Saved/" + str(saveName))):
		print("FAILED TO CREATE A DIR!! SAVE FILE EXISTS!")
		return
	dir.make_dir(str(saveName))
	save_Path = "res://Scenes/Saved/" + saveName + "/"
	print("Created save path: ",save_Path)
	pass

#Save packed map.
#Called from map scenes.
func _save_Map(packedMap, mapName):
	print("Map name : " ,mapName)
	ResourceSaver.save(save_Path + str(mapName) + ".tscn", packedMap)
	pass

#Save game function.
#Saves player data, player scene and global mission data.
func _save_Game():
	var global_data_file = File.new()
	global_data_file.open(save_Path + "Global_Data.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Save")
	for i in save_nodes:
		var save_data = i.call("_Save_Data");
		global_data_file.store_line(to_json(save_data))
	global_data_file.close() 
	
	var global_mission_file = File.new()
	if(!global_mission_file.file_exists(save_Path + "Global_Mission.txt")):
		global_mission_file.open(save_Path + "Global_Mission.txt", File.WRITE)
		global_mission_file.store_line(to_json(Global_MissionDataScript.Missions))
		global_mission_file.close()
		pass
	
	global_mission_file = File.new()
	global_mission_file.open(save_Path + "Global_Mission.txt", File.READ_WRITE)
	save_nodes = get_tree().get_nodes_in_group("Save_Mission")
	var currentLine = null
	for i in save_nodes:
		var save_data = i.call("_Save_Data");
		print("savedata ",save_data)
		currentLine = parse_json(global_mission_file.get_line())
		print("current line: " , currentLine)
		for i in save_data.keys():
			if(currentLine.has(i)):
				currentLine[i] = save_data[i]
				break
			
		global_mission_file.store_line(to_json(currentLine))
	global_data_file.close() 
	var packed_Player = PackedScene.new()
	packed_Player.pack(Player_Scene)
	ResourceSaver.save(save_Path + "Player_Scene.tscn", packed_Player)
	print("player saved to: ", save_Path)
	
	pass

#Load player.
#Load player scene from save direction.
func _load_Player(saveFile):
	var player = null
	var dir = Directory.new()
	dir.open(saveFile)
	if(dir.file_exists(save_Path + "Player_Scnee.tscn")):
		player = load(save_Path + "Player_Scene.tscn")
		Player_Scene = player.instance()
	else:
		#If player not found from save direction return
		return
	pass

#Load map.
#Check save direction for map.
#If map is not found, use default maps.
func _load_Map(mapFile):
	var map = null
	var dir = Directory.new()
	dir.open(save_Path)
	if(dir.file_exists(save_Path + mapFile + ".tscn")):
		map = load(save_Path + mapFile + ".tscn")  
		pass
	else:
		map = load("res://Scenes/" + mapFile + ".tscn")  
		pass
	Map_Scene = map.instance()
	pass