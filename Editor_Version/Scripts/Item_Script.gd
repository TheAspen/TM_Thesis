extends Node2D

var Pickable_Item_Scene

var Collision_Activated = false

var Item_Name = "Default Name"
var Icon_Texture
var Item_Type  = "Default"
var Item_Damage = 0
var Item_Health = 0
var Item_Uses = 0

func _ready():

	#Icon_Texture = get_node("Icon_Sprite").texture
	Pickable_Item_Scene = get_parent().get_node(self.name).get_child(4)
	_set_Item_Ground_Animation()
	_set_Item_Stats()
	pass
	
func _input(event):
	
	if(Collision_Activated && Input.is_action_just_pressed("player_Action")):
		_pick_Item()
		pass
		
	pass

func _load_Item(item):
	
	Pickable_Item_Scene = load("res://Scenes/" + item).instance()
	add_child(Pickable_Item_Scene)
	_set_Item_Stats()
	pass

func _reset_Item(item):
	Pickable_Item_Scene = item
	_set_Item_Stats()
	pass

func _set_Item_Ground_Animation():
	match Pickable_Item_Scene.MetaType:
		"Item":
			Pickable_Item_Scene.get_node("Item_Sprite").animation = "Ground"
			pass
		"Weapon":
			Pickable_Item_Scene.get_node("Weapon_Sprite").animation = "Ground"
			pass
		"Armor":
			Pickable_Item_Scene.get_node("Armor_Sprite").animation = "Ground"
			pass
			
	pass
func _set_Item_Stats():
	
	match Pickable_Item_Scene.MetaType:
		"Item":
			Icon_Texture = Pickable_Item_Scene.get_node("Icon_Sprite").texture
			Item_Name = Pickable_Item_Scene.Name
			Item_Type = Pickable_Item_Scene.Type
			Item_Damage = Pickable_Item_Scene.Damage
			Item_Health = Pickable_Item_Scene.Health
			Item_Uses = Pickable_Item_Scene.Uses
		
		"Weapon":
			Icon_Texture = Pickable_Item_Scene.get_node("Icon_Sprite").texture
			Item_Name = Pickable_Item_Scene._WeaponName
			Item_Type = Pickable_Item_Scene._WeaponType
		
		"Armor":
			Icon_Texture = Pickable_Item_Scene.get_node("Icon_Sprite").texture
			Item_Name = Pickable_Item_Scene.Name
			Item_Type = Pickable_Item_Scene.Type
	
	#If weapon or armor or item is child of ItemNode, it should be on ground
	#Thats why we set here ground animations on
	_set_Item_Ground_Animation()
	pass

func _pick_Item():
	
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode/PlayerHUD_BaseNode/Inventory_BaseNode")._add_ItemTo_Inventory(self,Pickable_Item_Scene)
	_delete_Item()
	

func _on_Item_Collision_area_shape_entered(area_id, area, area_shape, self_shape):
	
	if(area.name == "Player_Character"):
		Collision_Activated = true
		get_node("Label").visible = true
	
	pass 

func _delete_Item():
	
	self.queue_free()
	pass

func _on_Item_Collision_area_shape_exited(area_id, area, area_shape, self_shape):
	if(area == null):
		return
	if(area.name == "Player_Character"):
		Collision_Activated = false
		get_node("Label").visible = false
	pass # replace with function body
