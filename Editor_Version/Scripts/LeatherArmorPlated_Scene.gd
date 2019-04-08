extends Node2D

var MetaType = null

var Name = null
var Type = null
var Armor = null
var ArmorDurability = 0
var ArmorDurabilityMod = 0
var Icon_Texture = null 

const MAX_DURABILITY = 100

func _ready():
	
	MetaType = "Armor"
	Name = "Plated Leather Armor"
	Type = "Chest"
	Armor = 15
	ArmorDurability = MAX_DURABILITY
	ArmorDurabilityMod = 1
	#Main_Texture = get_node("Main_Sprite").texture
	Icon_Texture = get_node("Icon_Sprite").texture
	pass
	
func _use(slot_Index):
	

	get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode").ArmorBase_Scene._wear_Armor(self)
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._delete_Icon(slot_Index);
	
	pass