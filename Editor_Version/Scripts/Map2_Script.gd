extends Node2D

onready var Enviroment_Scene = preload("res://Scenes/Enviroment_Scene.tscn").instance()
var isSaved = false
export (String)var MapName
func _ready():
	z_index = -2
	Global_PlayerDataScript.Global_CurrentMap = self
	if(Global_LevelData.Map2 == null):
		Global_LevelData.Map2 = self
		pass
	pass

func _save_Map():
	var packed_Scene = PackedScene.new()
	packed_Scene.pack(self)
	get_tree().get_root().get_node("Base_BaseNode")._save_Map( packed_Scene, MapName)
	pass