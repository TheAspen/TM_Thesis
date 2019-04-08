extends Node
#Enums
enum States{Idle, Move, Attack, Speak, Hit, FallBack, Die, Follow}

#Class Variables
var CurrentState = null
var WayPoints = null
var CurrentWayPoint = 0
var MainTarget = null
var isAttacking = false
var FollowCooldown = false
var IdleTime = 0
var Idle_Timer = null
var isIdle = false
var TargetinArea = 0
var Follow_Timer = 0
var Follow_CooldownTime = 0

#NPC movement variables:
var NPC_Velocity = 0
var NPC_Speed = 100 #Get this from dummy!
var NPC_Position = Vector2(0,0)
var NPC_StartPoint = null

var _path = []
var temp = false
var deltaMovement = 0

const FLOAT_EPSILION = 0.1

func _ready():
	
	CurrentState = States.Move
	WayPoints = get_parent().NPC_Waypoints
	NPC_Position = get_parent().position
	IdleTime = get_parent().NPC_IdleTime
	TargetinArea = get_parent().get_node("TargetigArea")
	Follow_CooldownTime = get_parent().NPC_FollowCooldown
	pass
	
	
func _process(delta):
	
	_NPC_State_Update()
	pass

func _check_Area():
	
	
	pass
func _NPC_State_Update():
	_NPC_State_Machine(CurrentState)
	
	pass
func _NPC_State_Machine(state):
	match state:
		States.Idle:
			_NPC_Idle()
			return
		States.Move:
			_NPC_Movement()
			return
		States.Speak:
			_NPC_Speak()
			return
		States.Attack:
			_NPC_Attack()
			return
		States.Hit:
			_NPC_Hit()
			return
		States.FallBack:
			_NPC_FallBack()
			return
		States.Die:
			_NPC_Die()
			return
	
	print(state , " doesn't match! Check ", self, " !")
	pass
	
func _NPC_Idle():
	
	if(IdleTime == 0):
		CurrentState = States.Move
		return
	match get_parent().NPC_Direction:
		"Down":
			get_parent().npcAnimation_Hands = "Idle_Down"
			get_parent().npcAnimation_Torso = "Idle_Down"
			get_parent().npcAnimation_Head = "Idle_Down"
			get_parent().npcAnimation_Legs = "Idle_Down"
			
		"Up":
			get_parent().npcAnimation_Hands = "Idle_Up"
			get_parent().npcAnimation_Torso = "Idle_Up"
			get_parent().npcAnimation_Head = "Idle_Up"
			get_parent().npcAnimation_Legs = "Idle_Up"
			
		"Right":
			get_parent().npcAnimation_Head = "Idle_Right"
			get_parent().npcAnimation_Hands = "Idle_Right"
			get_parent().npcAnimation_Torso = "Idle_Right"
			get_parent().npcAnimation_Legs = "Idle_Right"
			
		"Left":
			get_parent().npcAnimation_Head = "Idle_Left"
			get_parent().npcAnimation_Hands = "Idle_Left"
			get_parent().npcAnimation_Torso = "Idle_Left"
			get_parent().npcAnimation_Legs = "Idle_Left"
			
	get_parent()._select_animation()
	
	if(!isIdle):
		Idle_Timer = Timer.new()
		Idle_Timer.set_one_shot(true)
		Idle_Timer.wait_time = IdleTime
		Idle_Timer.connect("timeout", self,"_NPC_Idle_Done")
		add_child(Idle_Timer)
		Idle_Timer.start()
		
		isIdle = true
		pass
	
	pass
func _NPC_Idle_Done():
	Idle_Timer.queue_free()
	isIdle = false
	CurrentState = States.Move
	pass
func _NPC_Movement():
	var target = null
	NPC_Position = get_parent().position
	
	if(MainTarget != null):
		#Follow the main target
		target = MainTarget.position
		pass
	
	if(WayPoints != null && MainTarget == null):
		#Use waypoints
		target = WayPoints.get_point_position(CurrentWayPoint)
		if(get_parent().position.distance_to(target) < 1):
			if(CurrentWayPoint < WayPoints.get_point_count() - 1):
				CurrentWayPoint = CurrentWayPoint + 1
				CurrentState = States.Idle
				pass
			else:
				CurrentWayPoint = 0 
				CurrentState = States.Idle
				pass
		pass
	
	var NPC_Velocity = Vector2(0,0)
	
	var path = get_node("../../../").get_node("MapNavMesh").get_simple_path(NPC_Position, target, true)

	if(int(path[1].x) < int(NPC_Position.x)):
		NPC_Velocity.x -= NPC_Speed
		get_parent().NPC_Direction = "Left"
		get_parent().npcAnimation_Head = "Walk_Left"
		get_parent().npcAnimation_Hands = "Walk_Left"
		get_parent().npcAnimation_Torso = "Walk_Left"
		get_parent().npcAnimation_Legs = "Walk_Left"
		pass
	if(int(path[1].x) > int(NPC_Position.x)):
		NPC_Velocity.x += NPC_Speed
		get_parent().NPC_Direction = "Right"
		get_parent().npcAnimation_Head = "Walk_Right"
		get_parent().npcAnimation_Hands = "Walk_Right"
		get_parent().npcAnimation_Torso = "Walk_Right"
		get_parent().npcAnimation_Legs = "Walk_Right"
		pass
	
	if(int(path[1].y) < int(NPC_Position.y)):
		NPC_Velocity.y -= NPC_Speed
		get_parent().NPC_Direction = "Up"
		get_parent().npcAnimation_Head = "Walk_Up"
		get_parent().npcAnimation_Hands = "Walk_Up"
		get_parent().npcAnimation_Torso = "Walk_Up"
		get_parent().npcAnimation_Legs = "Walk_Up"
		pass
	if(int(path[1].y) > int(NPC_Position.y)):
		NPC_Velocity.y += NPC_Speed
		get_parent().NPC_Direction = "Down"
		get_parent().npcAnimation_Head = "Walk_Down"
		get_parent().npcAnimation_Hands = "Walk_Down"
		get_parent().npcAnimation_Torso = "Walk_Down"
		get_parent().npcAnimation_Legs = "Walk_Down"
		pass
	if(NPC_Velocity.length() > 0):
		NPC_Velocity = NPC_Velocity.normalized() * NPC_Speed
		get_parent()._select_animation()
	else:
		CurrentState = States.Idle
		return
	
	get_parent().move_and_collide(NPC_Velocity * get_process_delta_time())
	
	pass

func _NPC_Speak():
	
	pass

func _NPC_Attack():
	
	pass
	
func _NPC_Hit():
	
	pass

func _NPC_FallBack():
	
	pass

func _NPC_Die():
	
	pass

func _Start_Follow_Timer():
	
	if(!FollowCooldown):
		Follow_Timer = Timer.new()
		Follow_Timer.set_one_shot(true)
		Follow_Timer.wait_time = Follow_CooldownTime
		Follow_Timer.connect("timeout", self,"_NPC_FollowTimer_Done")
		
		add_child(Follow_Timer)
		Follow_Timer.start()
		FollowCooldown = true
		pass
	
	pass
func _NPC_FollowTimer_Done():
	Follow_Timer.queue_free()
	FollowCooldown = false
	_Reset_Maintarget(null)
	CurrentState = States.Move
	pass
func _Reset_Maintarget(newTarget):
	
	MainTarget = newTarget
	pass

func _on_TargetigArea_area_shape_entered(area_id, area, area_shape, self_shape):
	
	if(get_parent().isAggressive && area.name == "Player_Character"):
		CurrentState = States.Move
		MainTarget = area.get_parent()
		print("Player Detected")
		pass
	pass # replace with function body


func _on_TargetigArea_area_shape_exited(area_id, area, area_shape, self_shape):
	
	if(get_parent().isAggressive && area.name == "Player_Character"):
		_Start_Follow_Timer()
		pass
	
	pass # replace with function body
