extends Area2D #THIS WAS NODE2D?????

var MetaType = null

var _WeaponName = "Default Name"
var _WeaponType = "Default Type"

var _MeleeWeapon = false
var _RangedWeapon = false
var _MagicWeapon = false
var _WeaponReach = 0
var _WeaponDamage = 0
var _WeaponDurability = 0
var _WeaponDurabilityMod = 0
var _WeaponCooldown = 0
var _CurrentWeaponDirection = "Default"

var Icon_Texture = null

const MAX_DURABILITY = 100

func _ready():
	
	MetaType = "Weapon"
	_WeaponName = "Short sword"
	_WeaponType = "Sword"
	_MeleeWeapon = true
	_RangedWeapon = false
	_WeaponReach = 10
	_WeaponDamage = 20
	_WeaponDurability = MAX_DURABILITY
	_WeaponDurabilityMod = 1
	_WeaponCooldown = 0.5
	_CurrentWeaponDirection = Global_PlayerDataScript.Global_CurrentWeaponDirection
	Icon_Texture = get_node("Icon_Sprite").texture
	#get_node("Collision_Down").disabled = true
	
	pass
func _set_WeaponPosition(position):
	get_node(".").position = position
	print(get_node(".").name) #Debug
	pass


func _on_Animation_animation_finished():
	get_node("Weapon_Sprite").play("Idle")
	get_node("Weapon_Sprite").rotation = 0
	get_parent().get_parent().get_node(".")._disableCollision(_CurrentWeaponDirection)
	get_parent().get_parent()._reset_weaponPosition(_CurrentWeaponDirection)
	pass 

func _set_GlobalData():
	Global_PlayerDataScript.Global_CurrentWeaponDirection = _CurrentWeaponDirection
	
	pass
	
	
func _activate_Weapon(target):
	
	#send hitted objectHardness to Weapon baseNode
	#var objectHardness = get object hardness
	#get_parent()._decrease_Durability(_WeaponDurability, _WeaponDurabilityMod, objectHardness)
	get_parent().get_parent()._do_Damage(target)
	pass
#This function is for inventory only! Will not work if is used somewhere else!!
func _use(slot_Index):
	
	get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode").WeaponBase_Scene._change_Weapon(self) #.get_node("Player_Scene").get_node("WeaponBase_Scene")#._change_Weapon(self)
	
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._delete_Icon(slot_Index);
	pass
	


func _on_ShortSword_BaseNode_area_shape_entered(area_id, area, area_shape, self_shape):
	#print("Area Id: " , area_id , "Area: ", area.name)
	#print(area.get_parent().get_parent().name)
	if(area.get_parent().get_parent().name == "NPC_BaseNode"):
		get_parent().get_parent()._do_Damage_toNPC(area)
		pass
	
	pass # replace with function body
