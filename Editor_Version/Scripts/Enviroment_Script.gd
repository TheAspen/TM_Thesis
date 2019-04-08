extends Node2D


onready var Item_Scene = preload("res://Scenes/Item_Scene.tscn").instance()
onready var Item_Scene2 = preload("res://Scenes/Item_Scene.tscn").instance()
onready var Item_Sword = preload("res://Scenes/Item_Scene.tscn").instance()
onready var Item_Bow = preload("res://Scenes/Item_Scene.tscn").instance()
onready var Item_Armor = preload("res://Scenes/Item_Scene.tscn").instance()
onready var Item_Armor2 = preload("res://Scenes/Item_Scene.tscn").instance()

func _ready():
	
	Global_PlayerDataScript.Global_CurrentEnviroment = self
	
	add_child(Item_Scene)
	add_child(Item_Scene2)
	add_child(Item_Sword)
	add_child(Item_Bow)
	add_child(Item_Armor)
	add_child(Item_Armor2)
	
	Item_Scene._load_Item("HP_Potion_Scene.tscn")
	Item_Scene2._load_Item("HP_Potion_Scene.tscn")
	Item_Sword._load_Item("ShortSword_Scene.tscn")
	Item_Armor._load_Item("LeatherArmorPlated_Scene.tscn")
	Item_Armor2._load_Item("LeatherArmor_Scene.tscn")
	Item_Bow._load_Item("ShortBow_Scene.tscn")
	
	Item_Scene2.position.x = 200
	Item_Sword.position.x = 150
	Item_Sword.position.y = 300
	Item_Bow.position.x = 200
	Item_Bow.position.y = 100
	Item_Armor.position.x = 500
	Item_Armor.position.y = 250
	
	Item_Armor2.position.y = 150
	
	pass

