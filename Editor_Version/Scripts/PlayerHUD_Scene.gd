extends CanvasLayer

onready var Player_Inventory_Scene = preload("res://Scenes/Inventory_Scene.tscn").instance()
onready var Player_Dialogue_Scene = preload("res://Scenes/PlayerDialogue_Scene.tscn").instance()

var hideInventory = true
var hideMenu = true
var LevelChanger = null

func _ready():
	add_child(Player_Inventory_Scene)
	add_child(Player_Dialogue_Scene)
	
	Player_Inventory_Scene.hide()
	Player_Dialogue_Scene.hide()
	
	get_node("Vertical_Bars/Horizontal_Bars/Health").value = Global_PlayerDataScript.Global_PlayerHP
	get_node("Menu").hide()
	get_node("Menu/YouSure").hide()
	get_node("Menu/Options").hide()
	get_node("Change_Level").hide()
	pass

#Not sure is this good place for input checks.
#Also stop player move while inventory is shown(?) - Done 
func _input(event):
	if(Input.is_action_just_pressed("player_show_inventory") && hideMenu == true):
		_show_Inventory()
		
		pass
	
	pass

#Show inventory, freeze other scenes except this and this childs.
func _show_Inventory():
	
	if(!hideInventory):
		Player_Inventory_Scene.hide()
		hideInventory = true
		get_tree().paused = false
		return;
	
	Player_Inventory_Scene.show()
	hideInventory = false
	get_tree().paused = true
	
	pass
	
func _add_HealthPoints(amount):
	
	get_node("Vertical_Bars/Horizontal_Bars/Health").value = get_node("Vertical_Bars/Horizontal_Bars/Health").value + amount
	
	
	pass

func _on_MenuButton_mouse_entered():
	_disable_Input()
	
	pass # replace with function body


func _on_MenuButton_mouse_exited():
	_enable_Input()
	pass # replace with function body

func _enable_Input():
	get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode/Weapon_BaseNode").EnableInput = true
	pass
	
func _disable_Input():
	get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode/Weapon_BaseNode").EnableInput = false
	pass

func _on_MenuButton_pressed():
	if(hideMenu):
		get_node("Menu").show()
		hideMenu = false
		get_tree().paused = true
		return
	
	get_node("Menu").hide()
	hideMenu = true
	get_tree().paused = false
	get_node("MenuButton").release_focus()
	pass # replace with function body




func _on_Continue_Button_pressed():
	get_node("Menu").hide()
	hideMenu = true
	get_tree().paused = false
	get_node("MenuButton").release_focus()
	pass # replace with function body

func _on_Save_Button_pressed():
	get_tree().get_root().get_node("Base_BaseNode")._save_Game()
	get_tree().get_root().get_node("Base_BaseNode").Map_Scene._save_Map()
	print("Trying to save a game")
	pass # replace with function body

func _on_Options_Button_pressed():
	get_node("Menu/Options").show()
	pass # replace with function body

func _show_Dialogue(NPC):
	Player_Dialogue_Scene.CurrentNPC = NPC
	Player_Dialogue_Scene.show()
	
	pass

func _on_Exit_Button_pressed():
	get_node("Menu/YouSure").show()
	pass # replace with function body


func _on_Yes_Button_pressed():
	get_tree().get_root().get_node("Base_BaseNode").Base_ReInit()
	pass # replace with function body


func _on_No_Button_pressed():
	get_node("Menu/YouSure").hide()
	pass # replace with function body

func _add_Quest(quest):
	for i in range(get_node("Quests").get_item_count()):
		if(get_node("Quests").get_item_text(i) == quest):
			return
	get_node("Quests").add_item(quest,null, true)
	pass

func _on_Quests_item_selected(index):
	pass # replace with function body


func _on_Journal_Button_pressed():
	if(get_node("Quests").visible == true):
		get_node("Quests").hide()
		return
	get_node("Quests").show()
	
	pass # replace with function body


func _on_Journal_Button_mouse_entered():
	_disable_Input()
	pass # replace with function body


func _on_Journal_Button_mouse_exited():
	_enable_Input()
	pass # replace with function body

func _on_Options_Back_Button_pressed():
	get_node("Menu/Options").hide()
	pass # replace with function body

#Level changer hud & functions:
func _show_ChangeLevel(_levelChanger):
	get_node("Change_Level").show()
	get_tree().paused = true
	LevelChanger = _levelChanger
	
	pass
func _on_Yes_Level_Button_pressed():
	LevelChanger._load_Map()
	get_node("Change_Level").hide()
	LevelChanger = null
	get_tree().paused = false
	pass # replace with function body
func _on_No_Level_Button_pressed():
	get_node("Change_Level").hide()
	get_tree().paused = false
	LevelChanger = null
	pass # replace with function body



