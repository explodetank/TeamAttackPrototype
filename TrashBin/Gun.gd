class_name GunType extends WeaponBase

# Specifies how accurate the gun is.

@export var base_weapon_data:GunResource:
	set(value):
		base_weapon_data = value

func secondary_ability(targets:Array[Node]):
	pass
	
func primary_attack(targets:Array[Node]):
	var get_target:Node = targets.pick_random()
	for i in range(base_weapon_data.burst):
		if get_target:
			var new_bullet:PhysicsBullet = base_weapon_data.projectile_type.instantiate()
			var target_pos:Vector2 = get_target.position
			
			var on_screen_position:Transform2D = fire_node.get_global_transform()
			var test_position:Vector2 = on_screen_position.origin
			var rotation_deviation = 100-base_weapon_data.accuracy
			rotation_deviation = rotation_deviation/2
			var deviation_degrees = randi_range(0,rotation_deviation)
			var rotate_direction = randi_range(0,1)
			if rotate_direction == 0: deviation_degrees = -deviation_degrees
			new_bullet.position = test_position
			new_bullet.presets(PhysicsBullet.preset_types.Only_Enemies)
			new_bullet.bullet_damage = base_weapon_data.weapon_damage
			new_bullet.gravity_scale = 0.1
			var direction_vector:Vector2 = test_position.direction_to(target_pos).rotated(deg_to_rad(deviation_degrees))
			new_bullet.linear_velocity = randf_range(1900,2200) * direction_vector
			get_tree().current_scene.add_child(new_bullet)
			await get_tree().create_timer(base_weapon_data.burst_speed).timeout
		else: break
func level_up():
	pass

func start_stats():
	pass

func _ready() -> void:
	start_stats()
