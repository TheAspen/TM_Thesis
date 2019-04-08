extends Area2D

var MetaType = null

var _WeaponName = "Default Name"
var _WeaponType = "Default Type"

var _MeleeWeapon = false
var _RangedWeapon = false
var _MagicWeapon = false
var _WeaponReach = 0
var _WeaponDamage = 0
var _WeaponCooldown = 0
var _CurrentWeaponDirection = "Default"

var Icon_Texture = null


func _ready():
	
	MetaType = "Weapon"
	_WeaponName = "Fist"
	_WeaponType = "Unarmed"
	_MeleeWeapon = true
	_RangedWeapon = false
	_WeaponReach = 0
	_WeaponDamage = 2
	_WeaponCooldown = 0
	_CurrentWeaponDirection = Global_PlayerDataScript.Global_CurrentWeaponDirection
	Icon_Texture = get_node("Icon_Sprite").texture
	
	pass
func _set_WeaponPosition(position):
	get_node(".").position = position
	#print(get_node(".").name) #Debug
	pass


func _on_Animation_animation_finished():
	get_node("Animation").play("Idle")
	get_node("Animation").rotation = 0
	get_parent().get_parent().get_node(".")._disableCollision(_CurrentWeaponDirection)
	pass 

func _set_GlobalData():
	Global_PlayerDataScript.Global_CurrentWeaponDirection = _CurrentWeaponDirection
	
	pass
	
	
func _do_Damage():
	
	
	pass
#This function is for inventory only! Will not work if is used somewhere else!!
func _use(slot_Index):
	
	get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode").WeaponBase_Scene._change_Weapon(self)
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._delete_Icon(slot_Index);
	pass
	

func _disable_All():
	get_node("Weapon_Sprite").visible = false
	get_node("Icon_Sprite").visible = false
	get_node("Collision_Down").disabled = true
	get_node("Collision_Up").disabled = true
	get_node("Collision_Right").disabled = true
	get_node("Collision_Left").disabled = true
	pass
func _enable_All():
	get_node("Weapon_Sprite").visible = true
	pass
func _on_ShortSword_BaseNode_area_shape_entered(area_id, area, area_shape, self_shape):
	#print("Area Id: " , area_id , "Area: ", area.name)
	_do_Damage();
	
	pass # replace with function body
