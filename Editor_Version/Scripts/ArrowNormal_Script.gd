extends Node2D

var Bullet_Speed = 0
var Bullet_Damage = 0
var Bullet_Lifespawn = 0
var Bullet_Velocity = Vector2(0,0)
var Bullet_Direction = "Default"
var Bullet_Timer = null
var Bullet_Recoil = 0
var hasRecoil = false


func _ready():
	Bullet_Speed = 800
	Bullet_Damage = 2
	Bullet_Lifespawn = 0.3
	hasRecoil = false
	
	Bullet_Timer = Timer.new()
	Bullet_Timer.set_one_shot(true)
	Bullet_Timer.wait_time = Bullet_Lifespawn
	Bullet_Timer.connect("timeout", self, "_destroyBullet")
	add_child(Bullet_Timer)
	Bullet_Timer.start()
	
	pass

func _process(delta):
	
	if(!hasRecoil):
		Bullet_Recoil = _recoil(get_parent().RangeRecoil)
		hasRecoil = true
		pass
	
	if(Bullet_Direction == "Down"):
		Bullet_Velocity.x = Bullet_Recoil
		Bullet_Velocity.y = Bullet_Speed
		get_node("Arrow_Collision").rotation_degrees = 90
		
	if(Bullet_Direction == "Up"):
		Bullet_Velocity.x = Bullet_Recoil
		Bullet_Velocity.y = -Bullet_Speed
		get_node("Arrow_Collision").rotation_degrees = 90
		
	if(Bullet_Direction == "Right"):
		Bullet_Velocity.x = Bullet_Speed
		Bullet_Velocity.y = Bullet_Recoil
		
	if(Bullet_Direction == "Left"):
		Bullet_Velocity.x = -Bullet_Speed
		Bullet_Velocity.y = Bullet_Recoil
		
	
	position += Bullet_Velocity * delta
	
	pass
	
func _recoil(recoilSeed):
	
	Bullet_Recoil = rand_range(-recoilSeed, recoilSeed)
	
	return Bullet_Recoil
	
func _destroyBullet():
	self.queue_free()
	pass
