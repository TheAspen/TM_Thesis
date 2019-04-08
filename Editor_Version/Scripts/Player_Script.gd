extends Node2D

onready var WeaponBase_Scene = preload ("res://Scenes/Weapon_Scene.tscn").instance()
onready var ArmorBase_Scene = preload("res://Scenes/Armor_Scene.tscn").instance()

# class member variables go here:
var playerDirection
var playerVelocity
var playerSpeed
var playerAnimation_Head
var playerAnimation_Hands
var playerAnimation_Torso
var playerAnimation_Legs
var playerAnimation
var playAnimation = false

var playerStrength = 0
var playerInventoryItems = 0
var isIdle = true
var isFight = false
var Collide = false

func _ready():
	#Set the camera:
	get_node("Player_Camera").make_current()
	add_child(ArmorBase_Scene)
	add_child(WeaponBase_Scene)
	
	WeaponBase_Scene.CurrentWeapon_Position = get_node("Player_Character/Down_WeaponPos").position
	
	#Load global variables to local variables:
	playerDirection = Global_PlayerDataScript.Global_PlayerDirection
	playerSpeed = Global_PlayerDataScript.Global_PlayerSpeed
	playerAnimation = Global_PlayerDataScript.Global_PlayerAnimation
	Global_PlayerDataScript.Global_PlayerIcon = get_node("Inventory_Sprite").texture
	playerStrength = Global_PlayerDataScript.Global_PlayerStrength
	print("Player strenght ", playerStrength)
	_load_SavedSettings()
	isIdle = false
	#Basic function init:
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._set_Inventory_Icon(get_node("Inventory_Sprite").texture)
	set_process_input(true)
	pass
func _load_defaultSettings():
	
	#Load default global variables
	pass
func _load_SavedSettings():
	#Load saved global variables
	var loaded_file = File.new()
	if(!loaded_file.file_exists(get_tree().get_root().get_node("Base_BaseNode").save_Path + "Global_Data.save")):
		print("No save file")
		return
	loaded_file.open(get_tree().get_root().get_node("Base_BaseNode").save_Path + "Global_Data.save", File.READ)
	var current_line = parse_json(loaded_file.get_line())
	if(current_line != null):
		print(current_line)
		for i in current_line.keys():
			if (i == "HP"):
				Global_PlayerDataScript.Global_PlayerHP = current_line["HP"]
				continue
			if (i == "Map"):
				get_tree().get_root().get_node("Base_BaseNode")._load_Map(current_line["Map"])
				continue
			if (i == "Inventory"):
				playerInventoryItems = current_line["Inventory"]
				continue
			if(i == "PosX"):
				self.position.x = current_line["PosX"]
				Global_PlayerDataScript.Global_PlayerPosition.x = self.position.x
				continue
			if(i == "PosY"):
				self.position.y = current_line["PosY"]
				print("posY setted")
				Global_PlayerDataScript.Global_PlayerPosition.y = self.position.y
				continue
	#print("player " , current_line)
	loaded_file.close()
	_load_SavedData()
	
	
	pass
func _load_SavedData():
	var folder = Directory.new()
	var path = get_tree().get_root().get_node("Base_BaseNode").save_Path
	var init
	if(folder.file_exists(path + "CurrentWeapon_Scene.tscn")):
		var weapon = load(path + "CurrentWeapon_Scene.tscn")
		init = weapon.instance()
		WeaponBase_Scene._load_Weapon_fromSave(init)
		get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._set_Icon_toInventory_Character(init,"Weapon_Slot")
		pass
	
	var armor = null
	if(folder.file_exists(path + "CurrentArmor_Head_Scene.tscn")):
		armor = load(path + "CurrentArmor_Head_Scene.tscn")
		init = armor.instance()
		ArmorBase_Scene._load_Armor_fromSave(init)
		get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._set_Icon_toInventory_Character(init,"Head_Slot")
		pass
	if(folder.file_exists(path + "CurrentArmor_Chest_Scene.tscn")):
		armor = load(path + "CurrentArmor_Chest_Scene.tscn")
		init = armor.instance()
		ArmorBase_Scene._load_Armor_fromSave(init)
		get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._set_Icon_toInventory_Character(init,"Chest_Slot")
		pass
	if(folder.file_exists(path + "CurrentArmor_Leg_Scene.tscn")):
		armor = load(path + "CurrentArmor_Leg_Scene.tscn")
		init = armor.instance()
		ArmorBase_Scene._load_Armor_fromSave(init)
		get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._set_Icon_toInventory_Character(init,"Leg_Slot")
		pass
	
	var item = null
	for i in range(playerInventoryItems):
		if(folder.file_exists(path + "Item" + str(i) + "_Scene.tscn")):
			item = load(path + "Item" + str(i) + "_Scene.tscn")
			init = item.instance()
			get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode").PlayerHUD_Scene.Player_Inventory_Scene._load_Item_fromSave(init)
			pass
		pass
	
	pass
func _input(event):
	
	
	pass
	
func _process(delta):
	
	if(Collide):
		return
	#Player Movement:
	playerVelocity = Vector2(0,0)
		
	if(Input.is_action_pressed("player_MoveRight")):
		playerVelocity.x += playerSpeed
		playerAnimation_Head = "Walk_Right"
		playerAnimation_Torso = "Walk_Right"
		playerAnimation_Hands = "Walk_Right"
		playerAnimation_Legs = "Walk_Right"
		playerDirection = "Right"
		WeaponBase_Scene._set_weaponPosition(get_node("Player_Character/Right_WeaponPos").position)
		ArmorBase_Scene._set_ArmorDirection(playerDirection)
		_set_zIndex_Value(get_node("Player_Character/Character/Head"), 1 )
		_set_zIndex_Value(WeaponBase_Scene,2)
		isIdle = false
		
	if(Input.is_action_pressed("player_MoveLeft")):
		playerVelocity.x -= playerSpeed
		playerAnimation_Head = "Walk_Left"
		playerAnimation_Torso = "Walk_Left"
		playerAnimation_Hands = "Walk_Left"
		playerAnimation_Legs = "Walk_Left"
		playerDirection = "Left"
		WeaponBase_Scene._set_weaponPosition(get_node("Player_Character/Left_WeaponPos").position)
		ArmorBase_Scene._set_ArmorDirection(playerDirection)
		_set_zIndex_Value(get_node("Player_Character/Character/Head"), 1 )
		_set_zIndex_Value(WeaponBase_Scene,2)
		isIdle = false
		
	if(Input.is_action_pressed("player_MoveUp")):
		playerVelocity.y -= playerSpeed 
		playerAnimation_Head = "Walk_Up"
		if(WeaponBase_Scene.WeaponInUse == true):
			playerAnimation_Torso = "Walk_Up_Weapon"
			playerAnimation_Hands = "Walk_Up_Weapon"
		else:
			playerAnimation_Torso = "Walk_Up"
			playerAnimation_Hands = "Walk_Up"
		playerAnimation_Legs = "Walk_Up"
		playerDirection = "Up"
		WeaponBase_Scene._set_weaponPosition(get_node("Player_Character/Up_WeaponPos").position)
		ArmorBase_Scene._set_ArmorDirection(playerDirection)
		_set_zIndex_Value(get_node("Player_Character/Character/Head"), 2 )
		_set_zIndex_Value(WeaponBase_Scene,0)
		isIdle = false
		
	if(Input.is_action_pressed("player_MoveDown")):
		playerVelocity.y += playerSpeed
		playerAnimation_Head = "Walk_Down"
		if(WeaponBase_Scene.WeaponInUse == true):
			playerAnimation_Torso = "Walk_Down_Weapon"
			playerAnimation_Hands = "Walk_Down_Weapon"
		else:
			playerAnimation_Torso = "Walk_Down"
			playerAnimation_Hands = "Walk_Down"
		playerAnimation_Legs = "Walk_Down"
		playerDirection = "Down"
		WeaponBase_Scene._set_weaponPosition(get_node("Player_Character/Down_WeaponPos").position)
		ArmorBase_Scene._set_ArmorDirection(playerDirection)
		_set_zIndex_Value(get_node("Player_Character/Character/Head"), 2 )
		_set_zIndex_Value(WeaponBase_Scene,2)
		isIdle = false
		
	#Not sure what this does?
	if(playerVelocity.length() > 0):
		playerVelocity = playerVelocity.normalized() * playerSpeed
		_select_animation(playerAnimation_Head, playerAnimation_Hands, playerAnimation_Torso, playerAnimation_Legs)
	else:
		if(!isIdle):
			match playerDirection:
				"Down":
					if(WeaponBase_Scene.WeaponInUse == true):
						playerAnimation_Hands = "Idle_Down_Weapon"
						playerAnimation_Torso = "Idle_Down_Weapon"
					else:
						playerAnimation_Hands = "Idle_Down"
						playerAnimation_Torso = "Idle_Down"
					playerAnimation_Head = "Idle_Down"
					playerAnimation_Legs = "Idle_Down"
					_select_animation(playerAnimation_Head, playerAnimation_Hands, playerAnimation_Torso, playerAnimation_Legs)
				"Up":
					if(WeaponBase_Scene.WeaponInUse == true):
						playerAnimation_Hands = "Idle_Up_Weapon"
						playerAnimation_Torso = "Idle_Up_Weapon"
					else:
						playerAnimation_Hands = "Idle_Up"
						playerAnimation_Torso = "Idle_Up"
					playerAnimation_Head = "Idle_Up"
					playerAnimation_Legs = "Idle_Up"
					_select_animation(playerAnimation_Head, playerAnimation_Hands, playerAnimation_Torso, playerAnimation_Legs)
				"Right":
					playerAnimation_Head = "Idle_Right"
					playerAnimation_Hands = "Idle_Right"
					playerAnimation_Torso = "Idle_Right"
					playerAnimation_Legs = "Idle_Right"
					_select_animation(playerAnimation_Head, playerAnimation_Hands, playerAnimation_Torso, playerAnimation_Legs)
				"Left":
					playerAnimation_Head = "Idle_Left"
					playerAnimation_Hands = "Idle_Left"
					playerAnimation_Torso = "Idle_Left"
					playerAnimation_Legs = "Idle_Left"
					_select_animation(playerAnimation_Head, playerAnimation_Hands, playerAnimation_Torso, playerAnimation_Legs)
					
			
			isIdle = true
		
	if(Input.is_action_pressed("player_UseWeapon") && WeaponBase_Scene.get_node("CurrentWeapon").get_child(0).get_node("Weapon_Sprite").animation != "Idle"):
		playerAnimation = "Fight_" + str(playerDirection)
		WeaponBase_Scene._set_weaponFightPosition(playerDirection)
		_select_fightingAnimation(playerAnimation)
	
	self.move_and_collide(playerVelocity * delta) #Change player position
	
	
	pass

func _select_fightingAnimation(anim):
	if(get_node("Player_Character/Character/Head").animation == anim && playAnimation):
		return
	get_node("Player_Character/Character/Head").animation = anim
	get_node("Player_Character/Character/Hands").animation = anim
	get_node("Player_Character/Character/Torso").animation = anim
	#_set_animation_play(anim)
	pass
func _select_animation(head,hands,torso,legs): #Animation selector:
	
	#Check if the anim is already playing:
	
	if(get_node("Player_Character/Character/Head").animation != head):
		get_node("Player_Character/Character/Head").animation = head
		
	if(get_node("Player_Character/Character/Hands").animation != hands):
		get_node("Player_Character/Character/Hands").animation = hands
	if(get_node("Player_Character/Character/Torso").animation != torso):
		get_node("Player_Character/Character/Torso").animation = torso
		print(get_node("Player_Character/Character/Torso").animation)
	if(get_node("Player_Character/Character/Legs").animation != legs):
		get_node("Player_Character/Character/Legs").animation = legs
	_set_animation_play(head,hands,torso,legs)
	pass

func _set_animation_play(head,hands,torso,legs):
	if(!get_node("Player_Character/Character/Head").is_playing()):
		get_node("Player_Character/Character/Head").play(head)
		playAnimation = true
	if(!get_node("Player_Character/Character/Hands").is_playing()):
		get_node("Player_Character/Character/Hands").play(hands)
		playAnimation = true
	if(!get_node("Player_Character/Character/Torso").is_playing()):
		get_node("Player_Character/Character/Torso").play(torso)
		playAnimation = true
	if(!get_node("Player_Character/Character/Legs").is_playing()):
		get_node("Player_Character/Character/Legs").play(legs)
		playAnimation = true
	
	
	pass

func _set_animation_stop():
	get_node("Player_Character/Character/Head").stop()
	get_node("Player_Character/Character/Hands").stop()
	get_node("Player_Character/Character/Torso").stop()
	get_node("Player_Character/Character/Legs").stop()
	
	playAnimation = false
	pass
	
#NOT IN USE!!
func _set_GlobalData():
	#Set Global variables:
	
#Player Stats
	Global_PlayerDataScript.Global_PlayerHP = 100
	Global_PlayerDataScript.Global_PlayerMana = 100
	Global_PlayerDataScript.Global_PlayerStamina = 100

#Player movement
	Global_PlayerDataScript.Global_PlayerSpeed = 180
	Global_PlayerDataScript.Global_PlayerDirection = playerDirection
	Global_PlayerDataScript.Global_PlayerPosition = Vector2(0,0)

#Player Armor and Sprites
	Global_PlayerDataScript.Global_PlayerHead_Armor = ArmorBase_Scene.get_node("Head_Armor")
	Global_PlayerDataScript.Global_PlayerChest_Armor = ArmorBase_Scene.get_node("Chest_Armor")
	Global_PlayerDataScript.Global_PlayerLegs_Armor = ArmorBase_Scene.get_node("Leg_Armor")
	Global_PlayerDataScript.Global_PlayerCharacter = self #(?)

#Player Weapon
	Global_PlayerDataScript.Global_Ammo = WeaponBase_Scene.Ammo
	Global_PlayerDataScript.Global_CurrentWeaponDirection = playerDirection
	Global_PlayerDataScript.Global_CurrentWeaponPosition = WeaponBase_Scene.CurrentWeapon_Position
	Global_PlayerDataScript.Global_CurrentWeaponNode = WeaponBase_Scene.get_node("CurrentWeapon").get_child(0)

#Player Current Map
	Global_PlayerDataScript.Global_CurrentMap = null
	Global_PlayerDataScript.Global_CurrentEnviroment = null
	
	#Player Items
	Global_PlayerDataScript.Global_Items = []
	
	#Player Animations
	Global_PlayerDataScript.Global_PlayerAnimation = playerAnimation


#Player Miscs:
	Global_PlayerDataScript.Global_PlayerName = "Player Name"
	
	
	
	pass
func _Save_Data():
	
	if(WeaponBase_Scene.get_node("CurrentWeapon").get_child_count() != 0 && WeaponBase_Scene.get_node("CurrentWeapon").get_child(0)._WeaponName != "Fist"):
		var packed_CurrentWeapon = PackedScene.new()
		packed_CurrentWeapon.pack(WeaponBase_Scene.get_node("CurrentWeapon").get_child(0))
		ResourceSaver.save(get_tree().get_root().get_node("Base_BaseNode").save_Path + "CurrentWeapon_Scene.tscn", packed_CurrentWeapon)
		pass
	
	if(ArmorBase_Scene.get_node("Head_Armor").get_child_count() != 0):
		var packed_CurrentHeadArmor = PackedScene.new()
		packed_CurrentHeadArmor.pack(ArmorBase_Scene.get_node("Head_Armor").get_child(0))
		ResourceSaver.save(get_tree().get_root().get_node("Base_BaseNode").save_Path + "CurrentArmor_Head_Scene.tscn", packed_CurrentHeadArmor)
		pass
	if(ArmorBase_Scene.get_node("Chest_Armor").get_child_count() != 0):
		var packed_CurrentChestArmor = PackedScene.new()
		packed_CurrentChestArmor.pack(ArmorBase_Scene.get_node("Chest_Armor").get_child(0))
		print("Chest armor ", ArmorBase_Scene.get_node("Chest_Armor").get_child(0).name)
		ResourceSaver.save(get_tree().get_root().get_node("Base_BaseNode").save_Path + "CurrentArmor_Chest_Scene.tscn", packed_CurrentChestArmor)
		pass
	if(ArmorBase_Scene.get_node("Leg_Armor").get_child_count() != 0):
		var packed_CurrentLegArmor = PackedScene.new()
		packed_CurrentLegArmor.pack(ArmorBase_Scene.get_node("Leg_Armor").get_child(0))
		ResourceSaver.save(get_tree().get_root().get_node("Base_BaseNode").save_Path + "CurrentArmor_Leg_Scene.tscn", packed_CurrentLegArmor)
		pass
	
	var inventory_Items = get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode/PlayerHUD_BaseNode").Player_Inventory_Scene.get_node("Items_Node")
	print("child count" , inventory_Items.get_child_count())
	for i in range(inventory_Items.get_child_count()):
		var packed_Item = PackedScene.new()
		packed_Item.pack(inventory_Items.get_child(i))
		ResourceSaver.save(get_tree().get_root().get_node("Base_BaseNode").save_Path + "Item" + str(i) + "_Scene.tscn", packed_Item)
		pass
	
	var save_data = {
	"HP" : Global_PlayerDataScript.Global_PlayerHP,
	"PosX": position.x,
	"PosY" : position.y,
	"Map" : get_parent().Map_Scene.MapName,
	"Inventory" : inventory_Items.get_child_count()}
	return save_data

func _on_Head_animation_finished():
	#NOT IN USE
	pass # replace with function body

func _set_zIndex_Value(object, value):
	if(object.z_index == value || object == null ):
		return
	object.z_index = value
	pass

func _on_Player_Character_area_shape_entered(area_id, area, area_shape, self_shape):
	#NOT IN USE
	pass # replace with function body

func _on_Player_Character_area_entered(area):
	print("hitted: " , area.name)
	if(area.name == "NPC_Character"):
		return
	pass # replace with function body
