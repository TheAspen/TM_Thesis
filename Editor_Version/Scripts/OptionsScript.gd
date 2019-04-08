extends Node

var reso_1280_800 = "1280 x 800"
var reso_800_600 = "800 x 600"
var reso_1280_1024 = "1280 x 1024"
var reso_1920_1200 = "1920 x 1200"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	_init_resolutions()
	pass

func _on_BackButton_pressed():
	print("option back button pressed")
	if(get_parent().previousScene == get_parent().PlayerHUD_Scene):
		get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").UI_ChangeCurrentState("PlayerHudState")
		return
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").UI_ChangeCurrentState("MainMenu_State")
	pass # replace with function body

func _init_resolutions():
	get_node("Panel/Resolution").get_popup().add_item(reso_800_600)
	get_node("Panel/Resolution").get_popup().add_item(reso_1280_800)
	get_node("Panel/Resolution").get_popup().add_item(reso_1280_1024)
	get_node("Panel/Resolution").get_popup().add_item(reso_1920_1200)
	get_node("Panel/Resolution").get_popup().connect("id_pressed",self,"_on_Item_Pressed")
	
	pass
func _on_Item_Pressed(ID):
	match get_node("Panel/Resolution").get_popup().get_item_text(ID):
		"1920 x 1200":
			_set_resolution(1920,1200)
			pass
		"1280 x 1024":
			_set_resolution(1280,1024)
			pass
		"1280 x 800":
			_set_resolution(1280,800)
			pass
		"800 x 600":
			_set_resolution(800,600)
			pass
	pass
func _set_resolution(x,y):
	OS.window_size.x = x
	OS.window_size.y = y #set_size_override(true,Vector2(x,y),Vector2(0,0))
	pass

func _on_Toggle_FullScreen_toggled(button_pressed):
	if(OS.window_fullscreen):
		OS.window_fullscreen = false
		return
	OS.window_fullscreen = true
	pass 
