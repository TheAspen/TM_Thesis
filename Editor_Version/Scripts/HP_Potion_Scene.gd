extends Node2D

var MetaType = null

var Name
var Type
var Damage
var Health
var Uses
#var Main_Texture
var Icon_Texture = null

func _ready():
	MetaType = "Item"
	Name = "Basic Potion"
	Type = "Potion"
	Damage = 0
	Health = 20
	Uses = 1
	#Main_Texture = get_node("Main_Sprite").texture
	Icon_Texture = get_node("Icon_Sprite").texture
	pass


func _use(slot_Index):
	get_parent().get_parent()._use_Item(Type,Health);
	Uses = Uses - 1
	if(Uses <= 0):
		get_parent().get_parent()._delete_UsedItem(slot_Index);
	pass