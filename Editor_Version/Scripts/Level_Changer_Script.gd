extends Area2D

export (String) var Next_Map 
export (String) var Spawn_Point

func _load_Map():
	
	get_tree().get_root().get_node("Base_BaseNode")._change_Map_Scene(Next_Map,Spawn_Point)
	pass
	
func _on_Level_Changer_area_entered(area):
	#print(area.name)
	if(area.name == "Player_Character"):
		get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").get_node("PlayerHUD_BaseNode")._show_ChangeLevel(self)
		get_parent().isSaved = true
		get_parent()._save_Map()
		
	pass # replace with function body


