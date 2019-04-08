extends Control

var player_ItemList = []
var Selected_Item = null
var Selected_ItemIndex = -1

export (Texture) var Rect_Texture_Normal
export (Texture) var Rect_Texture_Hovered

func _ready():
	
	#NOTE: Not in use!!
	player_ItemList = Global_PlayerDataScript.Global_Items
	if(player_ItemList.size() != 0):
		for i in range(player_ItemList.count()):
			get_node("Items_Node").add_child(player_ItemList[i])
			pass #Delete add_child if use list of list_with_variables!!!
	
	pass
func _input(event):
	
	#CHECK THIS FUNCTION! IS IT SAME ASE NORMAL USE BUTTON!!
	if(Selected_Item != null && event is InputEventMouseButton && event.doubleclick):
		get_node("Items_Node").get_child(Selected_ItemIndex)._use(Selected_ItemIndex)
		_reset_Variables()
		pass
	pass


func _set_Inventory_Icon(texture):
	get_node("Icon_Player").texture = texture
	pass
#Add new item to ItemList and player itemlist array.
func _add_ItemTo_Inventory(Item_Scene, item):
	
	#Item_Scene is item parent and it will be deleted after this function!
	#Reparent Item.
	Item_Scene.remove_child(item)
	get_node("Items_Node").add_child(item)
	#item.set_owner(get_node("Items_Node")) ## NOT SURE DO I NEED THIS??
	
	#NOTE:Figure out better way to save items!
	#player_ItemList.push_back(item)
	get_node("Horizontal_Container/ItemList").add_item(Item_Scene.Item_Name,item.Icon_Texture, true)
	#_debug_Print_ItemStats()
	pass
	
func _swap_ItemTo_Inventory(Parent_Scene, item, itemName):
	Parent_Scene.remove_child(item)
	get_node("Items_Node").add_child(item)
	get_node("Horizontal_Container/ItemList").add_item(itemName,item.Icon_Texture, true)
	pass
	
func _debug_Print_ItemStats():
	for i in range(player_ItemList.size()):
		print(player_ItemList[i].name)
	pass
	
#Delete icon from itemlist by index. This is uses mainly in weapon selection and swapping
func _delete_Icon(itemIndex):
	get_node("Horizontal_Container/ItemList").remove_item(itemIndex)
	pass
	
#Use item when it is usable from inventory
func _use_Item(Type, Data):
	match Type:
		"Potion":
			get_parent()._add_HealthPoints(Data)
			pass
		
	pass
#Delete item
func _delete_UsedItem(itemIndex):
	get_node("Horizontal_Container/ItemList").remove_item(itemIndex)
	get_node("Items_Node").get_child(itemIndex).queue_free()
	
	pass

func _reOrganize():
	var count = get_node("Horizontal_Container/ItemList").get_item_count()
	for i in range(count):
		get_node("Horizontal_Container/ItemList").get_item_text(i)
	pass


func _on_ItemList_item_selected(index): 
	
	Selected_Item = get_node("Items_Node").get_child(index)
	Selected_ItemIndex = index
	
	pass 

func _reset_Variables():
	
	Selected_Item = null
	Selected_ItemIndex = -1
	pass

func _on_Use_Button_pressed():
	
	if(Selected_Item == null):
		return
	
	get_node("Items_Node").get_child(Selected_ItemIndex)._use(Selected_ItemIndex)
	
	_reset_Variables()
	pass 

func _on_Delete_Button_pressed():
	
	if(Selected_Item == null):
		return
		
	_delete_Icon(Selected_ItemIndex)
	get_node("Items_Node").get_child(Selected_ItemIndex).queue_free()
	_reset_Variables()
	pass


func _on_Drop_Button_pressed():
	
	if(Selected_Item == null):
		return
	
	get_node("Items_Node").remove_child(Selected_Item)
	#TODO: Set current position for dropped item. Add somesort of functio to Item?
	#Dropped item should be child of item, not a enviroment directly. 
	_init_Dropped_Item(Selected_Item,get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode").position)
	_delete_Icon(Selected_ItemIndex)
	_reset_Variables()
	pass 


func _init_Dropped_Item(child,dropLocation):
	
	var newItemBase = load("res://Scenes/Item_Scene.tscn").instance()
	newItemBase.add_child(child)
	newItemBase._reset_Item(child)
	newItemBase.position = dropLocation
	get_tree().get_root().get_node("Base_BaseNode/" + Global_PlayerDataScript.Global_CurrentMap.name).get_node("Enviroment").add_child(newItemBase)
	pass
	
#Add icon to Inventory slot system
#Called in Armor base & Weapon Base Classes
func _set_Icon_toInventory_Character(item,pos):
	if(item == null):
		return
	if(item.MetaType == "Armor"):
		get_node("Current_Gear").get_node("Armor_Container").get_node(pos).get_child(0).texture_normal = item.Icon_Texture
		pass
	if(item.MetaType == "Weapon"):
		get_node("Current_Gear").get_node("Weapon_Container").get_node(pos).get_child(0).texture_normal = item.Icon_Texture
		pass
	pass
	
func _use_Inventory_CharacterButton(button):
	if(button.texture_normal == null):
		return
	print("test")
	pass

func _on_Weapon_pressed():
	
	if(get_node("Current_Gear/Weapon_Container/Weapon_Slot/Weapon").texture_normal == null):
		return
	get_node("Current_Gear/Weapon_Container/Weapon_Slot/Weapon").texture_normal = null
	get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode").get_node("Weapon_BaseNode")._take_WeaponOff()
	
	pass # replace with function body

func _on_Head_pressed():
	if(get_node("Current_Gear/Armor_Container/Head_Slot/Head").texture_normal == null):
		return
		
	get_node("Current_Gear/Armor_Container/Head_Slot/Head").texture_normal = null
	get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode").get_node("Armor_BaseNode")._take_ArmorOff("Head")
	pass # replace with function body

func _on_Chest_pressed():
	
	if(get_node("Current_Gear/Armor_Container/Chest_Slot/Chest").texture_normal == null):
		return
		
	get_node("Current_Gear/Armor_Container/Chest_Slot/Chest").texture_normal = null
	get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode").get_node("Armor_BaseNode")._take_ArmorOff("Chest")
	
	pass # replace with function body

func _on_Legs_pressed():
	if(get_node("Current_Gear/Armor_Container/Legs_Slot/Legs").texture_normal == null):
		return
		
	get_node("Current_Gear/Armor_Container/Legs_Slot/Legs").texture_normal = null
	get_tree().get_root().get_node("Base_BaseNode/Player_BaseNode").get_node("Armor_BaseNode")._take_ArmorOff("Legs")
	pass # replace with function body

func _set_Rect_Texture(slot, _texture):
	slot.texture = _texture
	pass
	

func _on_Head_mouse_entered():
	_set_Rect_Texture(get_node("Current_Gear/Armor_Container/Head_Slot"),Rect_Texture_Hovered)
	pass # replace with function body

func _on_Head_mouse_exited():
	_set_Rect_Texture(get_node("Current_Gear/Armor_Container/Head_Slot"),Rect_Texture_Normal)
	pass # replace with function body

func _on_Chest_mouse_entered():
	_set_Rect_Texture(get_node("Current_Gear/Armor_Container/Chest_Slot"),Rect_Texture_Hovered)
	pass # replace with function body
	
func _on_Chest_mouse_exited():
	_set_Rect_Texture(get_node("Current_Gear/Armor_Container/Chest_Slot"),Rect_Texture_Normal)
	pass # replace with function body
	
func _on_Legs_mouse_entered():
	_set_Rect_Texture(get_node("Current_Gear/Armor_Container/Legs_Slot"),Rect_Texture_Hovered)
	pass # replace with function body

func _on_Legs_mouse_exited():
	_set_Rect_Texture(get_node("Current_Gear/Armor_Container/Legs_Slot"),Rect_Texture_Normal)
	pass # replace with function body

func _on_Weapon_mouse_entered():
	_set_Rect_Texture(get_node("Current_Gear/Weapon_Container/Weapon_Slot"), Rect_Texture_Hovered)
	pass # replace with function body

func _on_Weapon_mouse_exited():
	_set_Rect_Texture(get_node("Current_Gear/Weapon_Container/Weapon_Slot"), Rect_Texture_Normal)
	pass # replace with function body

func _load_Item_fromSave(item):
	get_node("Items_Node").add_child(item)
	match item.MetaType:
		"Weapon":
			get_node("Horizontal_Container/ItemList").add_item(item._WeaponName,item.Icon_Texture, true)
		"Armor":
			get_node("Horizontal_Container/ItemList").add_item(item.Name,item.Icon_Texture, true)
		"Item":
			get_node("Horizontal_Container/ItemList").add_item(item.Name,item.Icon_Texture, true)
	pass




