extends Marker2D

var parry_skill:Skill
var heavy_strike_skill:Skill

var bullet_scene = preload("res://Scenes/BulletDictionary/bullet_particle_1.tscn")
var gun_bullet_scene = preload("res://Scenes/BulletDictionary/gun_bullet.tscn")

func _ready():
	parry_skill = load("res://Resources/BaseSkills/Parry.tres")
	heavy_strike_skill = load("res://Resources/DebuggingResources/SkillTest4.tres")
	parry_skill.set_skill_owner(self)
	heavy_strike_skill.set_skill_owner(self)
	$Timer.start()
	

func _on_timer_timeout() -> void:
	for i in range(3):
		var new_bullet:PhysicsBullet = gun_bullet_scene.instantiate()
		var retrieve_scene = get_tree().current_scene
		
		var bullet_deviation:int = randi_range(0,5)
		var rotation_type = randi_range(0,1)
		match rotation_type:
			0: bullet_deviation = -bullet_deviation
		
		var get_target:Marker2D = retrieve_scene.get_node("Target")
		
		new_bullet.position = position
		new_bullet.gravity_scale = 0.25
		var direction_vector = position.direction_to(get_target.position).rotated(deg_to_rad(bullet_deviation))
		new_bullet.linear_velocity = direction_vector * randi_range(1700,1800)
		
		#new_bullet.rotation = new_bullet.linear_velocity.angle() + (PI * 0.5)
		
		retrieve_scene.add_child(new_bullet)
		await get_tree().create_timer(0.1).timeout

	
	
