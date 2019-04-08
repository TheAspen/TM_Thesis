extends Node2D

var allowDialogue = false
var player_node = null

#Class Export variables
export (float)var NPC_IdleTime = 0 
export (Curve2D)var NPC_Waypoints = null
export (float)var NPC_TargetingArea = 0 
export (float)var NPC_FollowCooldown = 0
var NPC_Character = null
var NPC_Direction = "Down"
var npcAnimation_Head = null
var npcAnimation_Torso = null
var npcAnimation_Hands = null
var npcAnimation_Legs = null
var playAnimation = false

#These should come from NPC character (Dummy class):
var isEnemy = false
var isAlly = false
var isNeutral = false
var isAggressive = false

func _ready():
	get_node("TargetigArea/TargetingCollision").scale.x = NPC_TargetingArea
	get_node("TargetigArea/TargetingCollision").scale.y = NPC_TargetingArea
	NPC_Character = get_child(0)
	get_node("NPC_Collision").shape = NPC_Character.get_node("NPC_Character/Collision").shape
	get_node("NPC_Collision").scale = NPC_Character.get_node("NPC_Character/Collision").scale
	pass

func _input(event):
	if(allowDialogue && Input.is_action_just_pressed("player_Action")):
		_show_Dialog(player_node)
		pass
		
	
	pass
func _handle_damageEvent(target, damage):
	#function before do anything
	# ignore ally damage etc.
	_decrease_HealthPoints(target, damage)
	pass
func _decrease_HealthPoints(target, amount):
	target._HP = target._HP - amount
	print(target._HP)
	if(target._HP <= 0):
		_kill_Character(target)
		pass
	pass

func _kill_Character(target):
	#play dead animations
	#when animations ended, delete whole NPC.class
	_delete_NPC()
	pass
	
func _delete_NPC():
	self.queue_free()
	pass

func _on_Activation_Area_area_entered(area):
	print(area.name)
	if(area.name == "Player_Character"):
		allowDialogue = true
		player_node = area.get_parent()
		pass
	pass 

func _show_Dialog(player):
	get_node("NPC_Dialogue")._update_Dialog()
	get_tree().get_root().get_node("Base_BaseNode/UI_BaseNode/PlayerHUD_BaseNode")._show_Dialogue(get_child(0))
	pass

func _on_Activation_Area_area_exited(area):
	if(area.name == "Player_Character"):
		if(allowDialogue):
			allowDialogue = false
	pass

func _select_animation(): #Animation selector:
	
	if(NPC_Character.get_node("NPC_Character/Character/Head").animation != npcAnimation_Head):
		NPC_Character.get_node("NPC_Character/Character/Head").animation = npcAnimation_Head
		
	if(NPC_Character.get_node("NPC_Character/Character/Hands").animation != npcAnimation_Hands):
		NPC_Character.get_node("NPC_Character/Character/Hands").animation = npcAnimation_Hands
	if(NPC_Character.get_node("NPC_Character/Character/Torso").animation != npcAnimation_Torso):
		NPC_Character.get_node("NPC_Character/Character/Torso").animation = npcAnimation_Torso
	if(NPC_Character.get_node("NPC_Character/Character/Legs").animation != npcAnimation_Legs):
		NPC_Character.get_node("NPC_Character/Character/Legs").animation = npcAnimation_Legs
	_set_animation_play(npcAnimation_Head,npcAnimation_Hands,npcAnimation_Torso,npcAnimation_Legs)
	pass

func _set_animation_play(head,hands,torso,legs):
	if(!NPC_Character.get_node("NPC_Character/Character/Head").is_playing()):
		NPC_Character.get_node("NPC_Character/Character/Head").play(head)
		playAnimation = true
	if(!NPC_Character.get_node("NPC_Character/Character/Hands").is_playing()):
		NPC_Character.get_node("NPC_Character/Character/Hands").play(hands)
		playAnimation = true
	if(!NPC_Character.get_node("NPC_Character/Character/Torso").is_playing()):
		NPC_Character.get_node("NPC_Character/Character/Torso").play(torso)
		playAnimation = true
	if(!NPC_Character.get_node("NPC_Character/Character/Legs").is_playing()):
		NPC_Character.get_node("NPC_Character/Character/Legs").play(legs)
		playAnimation = true
	pass