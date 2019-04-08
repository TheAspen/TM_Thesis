extends Node2D

onready var DefaultWeapon = preload ("res://Scenes/Unarmed_Scene.tscn").instance()

var WeaponName = "Default Name"
var WeaponType = "Default Type"

var MeleeWeapon = false
var RangedWeapon = false
var MagicWeapon = false
var WeaponReach = 10
var RangeRecoil = 0
var WeaponCooldown = 0
var Cooldown = false
var Activated = false
var WeaponInUse = false
var CurrentWeapon_Position = Vector2(0,0)
var PlayerDirection = "Down"
var TotalDamage_Output = 0
var WeaponDamage = 0

var Cooldown_Timer = null
var Ammo = 10

var EnableInput = true

func _ready():
	#Do some checks here? If weapon in global data load that?
	get_node("CurrentWeapon").add_child(DefaultWeapon)
	#Not sure about this, might need better initialation.
	WeaponName = get_node("CurrentWeapon").get_child(0)._WeaponName
	WeaponType = get_node("CurrentWeapon").get_child(0)._WeaponType
	MeleeWeapon = get_node("CurrentWeapon").get_child(0)._MeleeWeapon
	RangedWeapon = get_node("CurrentWeapon").get_child(0)._RangedWeapon
	MagicWeapon = get_node("CurrentWeapon").get_child(0)._MagicWeapon
	WeaponReach = get_node("CurrentWeapon").get_child(0)._WeaponReach
	WeaponCooldown = get_node("CurrentWeapon").get_child(0)._WeaponCooldown
	WeaponDamage = get_node("CurrentWeapon").get_child(0)._WeaponDamage
	_set_weaponPosition(Global_PlayerDataScript.Global_CurrentWeaponPosition)
	TotalDamage_Output = WeaponDamage * get_parent().playerStrength
	
	Cooldown_Timer = Timer.new()
	Cooldown_Timer.set_one_shot(true)
	Cooldown_Timer.connect("timeout", self, "_reset_weaponCooldown")
	add_child(Cooldown_Timer)
	
	EnableInput = true
	pass

func _process(delta):
	
	pass

func _set_weaponPosition(pos):
	if(CurrentWeapon_Position == pos):
		return
	get_node("CurrentWeapon").get_child(0).get_node(".").position = pos
	CurrentWeapon_Position = pos
	pass
	
#Forced weapon position setter. DO NOT USE IN LOOPS!
func _set_forced_weaponPosition(pos):
	get_node("CurrentWeapon").get_child(0).get_node(".").position = pos
	CurrentWeapon_Position = pos
	pass
	
#If player press hit, check weapon and do method.
func _input(event):
	if(Input.is_action_just_pressed("player_UseWeapon")):
		if(!EnableInput && event is InputEventMouseButton):
			return
		PlayerDirection = get_parent().playerDirection
		#print(PlayerDirection)
		if(MeleeWeapon):
			
			match PlayerDirection:
				"Up":
					_meleeHit("Hit_Up", PlayerDirection,0)
				"Down":
					_meleeHit("Hit_Down", PlayerDirection,3.14)
				"Right":
					_meleeHit("Hit_Right", PlayerDirection,1.57)
				"Left":
					_meleeHit("Hit_Left", PlayerDirection,-1.57)
			return
		if(RangedWeapon):
			_rangedShot(PlayerDirection)
			return
		else:
			print("NO MELEE OR RANGED WEAPON")
	
	pass

#Set Stats.
func _setWeaponStats():
	WeaponName = get_node("CurrentWeapon").get_child(0)._WeaponName
	WeaponType = get_node("CurrentWeapon").get_child(0)._WeaponType
	MeleeWeapon = get_node("CurrentWeapon").get_child(0)._MeleeWeapon
	RangedWeapon = get_node("CurrentWeapon").get_child(0)._RangedWeapon
	MagicWeapon = get_node("CurrentWeapon").get_child(0)._MagicWeapon
	WeaponReach = get_node("CurrentWeapon").get_child(0)._WeaponReach
	WeaponCooldown = get_node("CurrentWeapon").get_child(0)._WeaponCooldown
	WeaponDamage = get_node("CurrentWeapon").get_child(0)._WeaponDamage
	_reCalculate_TotalDamage()
	pass

#Update totalDamage
func _reCalculate_TotalDamage():
	TotalDamage_Output = WeaponDamage * get_parent().playerStrength
	print("recalculated damage output ", TotalDamage_Output)
	pass

#Set Activated
func _setActivated(value):
	Activated = value
	pass
	
func _meleeHit(anim,direction,rot):
	
	if(Cooldown):
		return
	
	_setActivated(true)
	_set_weaponRotation(rot)
	_set_weaponAnimation_play(anim)
	_enableCollision(direction)
	
	if(WeaponCooldown != 0):
		Cooldown_Timer.wait_time = WeaponCooldown
		Cooldown_Timer.start()
		Cooldown = true
		pass
	#Check if direction is changed and disable old collision before changing the current direction
	#Otherwise there is a chance that old collision remains active
	if(get_node("CurrentWeapon").get_child(0)._CurrentWeaponDirection != direction && get_node("CurrentWeapon").get_child(0)._CurrentWeaponDirection != "Default"):
		_disableCollision(get_node("CurrentWeapon").get_child(0)._CurrentWeaponDirection)
		pass
	get_node("CurrentWeapon").get_child(0)._CurrentWeaponDirection = direction
	pass

func _rangedShot(direction):
	
	#print(direction)
	if(Cooldown):
		return
	#Set recoil for ammo
	RangeRecoil = get_node("CurrentWeapon").get_child(0)._RangeRecoil
	
	if(Ammo != 0):
		_setActivated(true)
		get_node("CurrentWeapon").get_child(0)._SpawnBullet(direction)
		Ammo = Ammo - 1
		print(WeaponCooldown)
		if(WeaponCooldown != 0):
			Cooldown_Timer.wait_time = WeaponCooldown
			Cooldown_Timer.start()
			Cooldown = true
			pass
	else:
		print("OUT OF AMMO!!")
	
	pass
	
func _set_weaponFightPosition(direction):
	
	match direction:
		"Up":
			_set_weaponPosition(get_parent().get_node("Player_Character/Up_HitPos").position)
		"Down":
			_set_weaponPosition(get_parent().get_node("Player_Character/Down_HitPos").position)
		"Left":
			_set_weaponPosition(get_parent().get_node("Player_Character/Left_HitPos").position)
		"Right":
			_set_weaponPosition(get_parent().get_node("Player_Character/Right_HitPos").position)
	pass
func _reset_weaponPosition(direction):
	get_parent().isIdle = false
	match direction:
		"Up":
			_set_weaponPosition(get_parent().get_node("Player_Character/Up_WeaponPos").position)
		"Down":
			_set_weaponPosition(get_parent().get_node("Player_Character/Down_WeaponPos").position)
		"Left":
			_set_weaponPosition(get_parent().get_node("Player_Character/Left_WeaponPos").position)
		"Right":
			_set_weaponPosition(get_parent().get_node("Player_Character/Right_WeaponPos").position)
	pass
func _reset_weaponCooldown():
	Cooldown = false
	pass
	
func _enableCollision(direction):
	get_node("CurrentWeapon").get_child(0).get_node("Collision_" + direction).disabled = false
	pass
	
func _disableCollision(direction):
	get_node("CurrentWeapon").get_child(0).get_node("Collision_" + direction).disabled = true
	_setActivated(false)
	#_reset_weaponPosition(direction)
	pass 

func _set_weaponRotation(rotation):
	#Use radians!!!
	get_node("CurrentWeapon").get_child(0).get_node("Weapon_Sprite").rotation = rotation
	pass

func _set_weaponAnimation_play(anim):
	get_node("CurrentWeapon").get_child(0).get_node("Weapon_Sprite").play(anim)
	pass

func _set_weaponAnimation_stop(anim):
	get_node("CurrentWeapon").get_child(0).get_node("Weapon_Sprite").stop()
	pass

#Use this when weapon is taken away from weapon slot, default weapon will be setted back to slot.
func _take_WeaponOff():
	
	if(!WeaponInUse):
		return
	
	_send_WeaponToInventory(get_node("CurrentWeapon").get_child(0))
	
	DefaultWeapon._enable_All()
	remove_child(DefaultWeapon)
	get_node("CurrentWeapon").add_child(DefaultWeapon)
	
	WeaponInUse = false
	_setWeaponStats()
	_set_forced_weaponPosition(CurrentWeapon_Position)
	_set_weaponAnimation_play("Idle")
	#This is for updating character animations.
	get_parent().isIdle = false
	pass

#Use this function to communicate with player inventory.
#Change weapon
func _change_Weapon(newWeapon_Scene):
	
	#TODO: Check if there is weapon in hand and it is not a fist!
	#NOTE: This check is weapon in use & if it is not reparent default weapon (fist)
	#TODO: Reset WeaponInUse somehow!!
	if(WeaponInUse):
		_send_WeaponToInventory(get_node("CurrentWeapon").get_child(0))
		pass
	else:
		_disable_DefaultWeapon()
		pass
	WeaponInUse = true
	#Set Icon to the inventory character in weapon slot:
	print(newWeapon_Scene.get_parent().get_parent().name)
	newWeapon_Scene.get_parent().get_parent()._set_Icon_toInventory_Character(newWeapon_Scene,"Weapon_Slot")
	
	newWeapon_Scene.get_parent().remove_child(newWeapon_Scene)
	get_node("CurrentWeapon").add_child(newWeapon_Scene)
	
	_setWeaponStats()
	_set_forced_weaponPosition(CurrentWeapon_Position)
	_set_weaponAnimation_play("Idle")
	#This is for updating character animations.
	get_parent().isIdle = false
	pass
func _load_Weapon_fromSave(loadedWeapon):
	_disable_DefaultWeapon()
	get_node("CurrentWeapon").add_child(loadedWeapon)
	
	_setWeaponStats()
	_set_forced_weaponPosition(CurrentWeapon_Position)
	WeaponInUse = true
	print("Weapon lock & loaded!")
	pass
func _disable_DefaultWeapon():
	DefaultWeapon._disable_All()
	get_node("CurrentWeapon").remove_child(DefaultWeapon)
	add_child(DefaultWeapon)
	pass
#Use this function to communicate with player inventory.
#Send weapon from hand to the inventory
func _send_WeaponToInventory(weapon_Scene):
	
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._swap_ItemTo_Inventory(get_node("CurrentWeapon"),weapon_Scene, weapon_Scene._WeaponName)
	pass
	
func _decrease_Durability(weaponDurability, weaponDurabilityMod, objectHardness):
	#DURABILITY
	#var newDurability = weaponDurability - weaponDurabilityMod * objectHardness
	#send newDurability to weapon durability
	
	pass
func _increase_Durability(weaponDurability, value):
	
	var newDurability = weaponDurability + value
	#if(newDurability > get weapon MAX_DURABILITY):
		#newDurability = MAX_Durability
	#send newDurability to weapon durability
	pass
	
func _do_Damage_toNPC(target):
	print(target.get_parent().name)
	print("damage output", TotalDamage_Output)
	target.get_parent().get_parent()._handle_damageEvent(target.get_parent(),TotalDamage_Output)
	
	pass
func _set_ParentAnimation(direction):
	#print("Direction ", direction)
	match direction:
		"Down":
			get_parent().playerAnimation = "Fight_Down"
			get_parent()._select_animation("Fight_Down")
			return
	
	pass