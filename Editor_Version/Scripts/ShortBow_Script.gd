extends Node2D

var bullet_scene = preload("res://Scenes/ArrowNormal_Scene.tscn")

var MetaType = null 

var _WeaponName = "Default Name"
var _WeaponType = "Default Type"

var _MeleeWeapon = false
var _RangedWeapon = false
var _MagicWeapon = false
var _WeaponReach = 0
var _WeaponDamage = 0
var _WeaponFirerate = 0
var _RangeRecoil = 0
var _WeaponDurability = 0
var _WeaponDurabilityMod = 0
var _WeaponCooldown = 0
var _CurrentWeaponDirection = "Default"

var Icon_Texture = null

const MAX_DURABILITY = 100

func _ready():
	MetaType = "Weapon"
	_WeaponName = "Short bow"
	_WeaponType = "Bow"
	_MeleeWeapon = false
	_RangedWeapon = true
	_WeaponDamage = 15
	_WeaponFirerate = 1.5
	_RangeRecoil = 400
	_WeaponDurability = MAX_DURABILITY
	_WeaponDurabilityMod = 1
	_WeaponCooldown = 1.5
	_CurrentWeaponDirection = Global_PlayerDataScript.Global_CurrentWeaponDirection
	Icon_Texture = get_node("Icon_Sprite").texture
	#get_node("Collision_Down").disabled = true
	
	

	
	pass

func _SpawnBullet(direction):
	
	var clone = bullet_scene.instance()
	clone.Bullet_Direction = direction
	get_parent().get_parent().add_child(clone)
	
	pass

func _set_WeaponPosition(position):
	get_node(".").position = position
	print(get_node(".").name) #Debug
	pass
	
func _on_Animation_animation_finished():
	get_node("Animation").play("Idle")
	get_node("Animation").rotation = 0
	get_parent().get_node(".")._disableCollision(_CurrentWeaponDirection)
	pass 
	
func _use(slot_Index):

	get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode").WeaponBase_Scene._change_Weapon(self) #.get_node("Player_Scene").get_node("WeaponBase_Scene")#._change_Weapon(self)
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._delete_Icon(slot_Index);
	pass
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
