extends Control

onready var MainMenuUI_Scene = preload ("res://Scenes/MainMenuScene.tscn").instance()
onready var OptionsUI_Scene = preload ("res://Scenes/OptionsScene.tscn").instance()
#onready var PlayerHUD_Scene = preload ("res://Scenes/PlayerHUD_Scene.tscn").instance()
#var PlayerHUD_Scene = null

var PlayerHUD_Scene = null
var previousScene = null
var currentUI_Scene = 0
var MainMenu_State = "MainMenuState"
var Options_State = "OptionsState"
var PlayerHud_State = "PlayerHudState"
var default_State = "defaultState"
var Current_State = 0
var Init_PlayerHUD = true

func _ready():
	
	Current_State = default_State
	currentUI_Scene = MainMenuUI_Scene
	UI_ProcessState()
	pass
func _load_Default_PlayerHUD():
	PlayerHUD_Scene = preload("res://Scenes/PlayerHUD_Scene.tscn").instance()
	pass
func UI_ChangeCurrentState(new_State):
	Current_State = new_State
	UI_ProcessState()
	pass

func UI_RemoveCurrentScene():
	previousScene = currentUI_Scene
	remove_child(currentUI_Scene)
	pass
func UI_PlayerHUD_Init():
	if(Init_PlayerHUD):
		_load_Default_PlayerHUD()
		add_child(PlayerHUD_Scene)
		Init_PlayerHUD = false
	pass

func UI_MainMenu_Init():
	Init_PlayerHUD = true
	add_child(MainMenuUI_Scene)
	pass

func UI_Options_Init():
	add_child(OptionsUI_Scene)
	pass
func UI_ProcessState():
	#SIIRRÄ CHILDEJÄ OIKEAAN JÄRJESTYKSEEN, MIKÄ PIIRRETÄÄN PÄÄLLE!
	#KUN PELAAJAN UI PIIRRETÄÄN POISTETAAN MENUN UI
	#KUN PELISTÄ PALATAAN TAKAISIN PÄÄMENUUN POISTETAAN PELAAJAN UI
	#JA PIIRRETÄÄM MENU UI
	#UI_RemoveCurrentScene()
	
	match Current_State:
		
		"MainMenu_State":
			UI_RemoveCurrentScene()
			UI_MainMenu_Init()
			currentUI_Scene = MainMenuUI_Scene
			print("CurrentState is " + Current_State)
		"OptionsState":
			UI_RemoveCurrentScene()
			UI_Options_Init()
			currentUI_Scene = OptionsUI_Scene
			print("CurrentState is " + Current_State)
		"PlayerHudState":
			UI_RemoveCurrentScene()
			UI_PlayerHUD_Init()
			currentUI_Scene = PlayerHUD_Scene
			print("CurrentState is " + Current_State)
		"defaultState":
			add_child(MainMenuUI_Scene)
			currentUI_Scene = MainMenuUI_Scene
			print("CurrentState is " + Current_State)
	
	pass

	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
