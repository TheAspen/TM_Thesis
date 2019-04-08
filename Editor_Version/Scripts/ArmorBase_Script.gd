extends Node2D

#onready var CurrentArmor_Scene = preload ("res://Scenes/LeatherArmorPlated_Scene.tscn").instance()
#var CurrentArmor_Scene
var Armor_Type
var Armor_Value_Total
var Armor_Position

var hasHeadArmor = false
var hasChestArmor = false
var hasLegArmor = false


func _ready():
	Armor_Type = "Default"
	Armor_Value_Total = 0
	Armor_Position = Vector2(0,0) #Place here some position from parent class
	pass

func _take_ArmorOff(armorType):
	
	if(get_node(armorType + "_Armor").get_child(0) == null):
		return
	
	match armorType:
		"Helmet":
			hasHeadArmor = false
			pass
		"Chest":
			hasChestArmor = false
			pass
		"Legs":
			hasLegArmor = false
			pass
	
	_send_ArmorToInventory(get_node(armorType + "_Armor").get_child(0))
	
	
	
	pass
#Used when armor is weared.
func _wear_Armor(armor):
	
	armor.get_parent().get_parent()._set_Icon_toInventory_Character(armor,armor.Type + "_Slot")
	armor.get_parent().remove_child(armor)
	match armor.Type:
		"Helmet":
			if(hasHeadArmor):
				_change_Armor(armor)
				pass
			else:
				get_node("Head_Armor").add_child(armor)
				hasHeadArmor = true
			pass
		"Chest":
			if(hasChestArmor):
				_change_Armor(armor)
				pass
			else:
				get_node("Chest_Armor").add_child(armor)
				hasChestArmor = true
			pass
		"Legs":
			if(hasLegArmor):
				_change_Armor(armor)
				pass
			else:
				get_node("Leg_Armor").add_child(armor)
				hasLegArmor = true
			pass
			
	Armor_Value_Total = Armor_Value_Total + armor.Armor
	_set_ArmorPosition(armor.Type)
	_set_ArmorDirection(get_parent().playerDirection)
	
	pass
	
#Set Armor sprite direction and animations
func _set_ArmorDirection(direction):
	
	match(direction):
		"Up":
			#CALL _SET_ANIMATION() HERE, FOR ALL ARMORS!!! HEAD, CHEST & LEGS
			if(hasChestArmor):
				get_node("Chest_Armor").get_child(0).get_node("Armor_Sprite").animation = "Back"
			pass
		"Down":
			if(hasChestArmor):
				get_node("Chest_Armor").get_child(0).get_node("Armor_Sprite").animation = "Front"
			pass
		"Right":
			if(hasChestArmor):
				get_node("Chest_Armor").get_child(0).get_node("Armor_Sprite").animation = "Right"
			pass
		"Left":
			if(hasChestArmor):
				get_node("Chest_Armor").get_child(0).get_node("Armor_Sprite").animation = "Left"
			pass
	
	pass

#Set animations on play or stop them.
func _set_Animation(anim):
	#TODO: CHECK IS ANIMATION PLAYING AND IS ANIMATION ALREADY SET!!!
	
	
	pass

#Set armor in to right position.
func _set_ArmorPosition(armorType):
	
	match(armorType):
		"Helmet":
			get_node("Head_Armor").position = get_parent().get_node("Player_Character/Head_ArmorPos").position
			pass
		"Chest":
			get_node("Chest_Armor").position = get_parent().get_node("Player_Character/Chest_ArmorPos").position
			pass
		"Legs":
			#get_node("Leg_Armor").position = get_parent().get_node("Player_Character/Leg_ArmorPos").position
			pass
		"Default":
			
			pass
	pass
	
#If armor is already weared, send amor to the inventory.
func _change_Armor(newArmor_Scene):
	match newArmor_Scene.Type:
		"Helmet":
			_send_ArmorToInventory(get_node("Head_Armor").get_child(0))
			get_node("Head_Armor").add_child(newArmor_Scene)
			pass
		"Chest":
			_send_ArmorToInventory(get_node("Chest_Armor").get_child(0))
			get_node("Chest_Armor").add_child(newArmor_Scene)
			pass
		"Legs":
			pass
		
	
	#_setWeaponStats()
	pass
#Use this function to communicate with player inventory.
#Send armor from player to the inventory
func _send_ArmorToInventory(armor_Scene):
	match armor_Scene.Type:
		"Helmet":
			get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._swap_ItemTo_Inventory(get_node("Head_Armor"),armor_Scene, armor_Scene.Name)
			pass
		"Chest":
			get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._swap_ItemTo_Inventory(get_node("Chest_Armor"),armor_Scene,armor_Scene.Name)
			pass
		"Legs":
			pass
	
	pass
	
func _decrease_Durability(armorDurability, armorDurabilityMod, dmgTaken):
	#DURABILITY
	#var newDurability = armorDurability - armorDurabilityMod * dmgTaken #not sure about this? might need another own modifier(?)
	#send newDurability to Armor durability
	
	pass
func _increase_Durability(armorDurability, value):
	
	var newDurability = armorDurability + value
	#send newDurability to armor durability
	pass

func _load_Armor_fromSave(loadedArmor):
	#Have to call ready for initialize variables
	loadedArmor._ready()
	match loadedArmor.Type:
		"Helmet":
			get_node("Head_Armor").add_child(loadedArmor)
			hasHeadArmor = true
			pass
		"Chest":
			get_node("Chest_Armor").add_child(loadedArmor)
			hasChestArmor = true
			pass
		"Legs":
			get_node("Leg_Armor").add_child(loadedArmor)
			hasLegArmor = true
			pass
			
	Armor_Value_Total = Armor_Value_Total + loadedArmor.Armor
	_set_ArmorPosition(loadedArmor.Type)
	_set_ArmorDirection(get_parent().playerDirection)
	pass
	