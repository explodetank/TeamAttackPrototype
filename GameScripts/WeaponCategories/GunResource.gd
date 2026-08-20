class_name GunScript extends WeaponAttack

@export_range(0,100) var accuracy:int
@export var burst:int
@export var burst_speed:float = 0.1
@export var projectile_speed:float
@export var projectile_type:PackedScene
@export var target_group:String = "Enemy"
@export var base_bullet_damage:int

var current_level:int = 0
var bullet_damage:int = base_bullet_damage

@export var level_damage_scale:int = 5
@export var attribute_damage_scale:int = 3
@export var attribute_point_scale:int = 4

func level_up(new_level:int) -> void:
	current_level = new_level
	bullet_damage = base_bullet_damage + (level_damage_scale * current_level)

func trigger(owner:EntityCore,fire_node:Node,scene_tree:SceneTree):
	var targets:Array[Node] = scene_tree.get_nodes_in_group(target_group)
	var get_target:Node = targets.pick_random()
	for i in range(burst):
		if get_target:
			var new_bullet:PhysicsBullet = projectile_type.instantiate()
			var target_pos:Vector2 = get_target.position
			
			var on_screen_position:Transform2D = fire_node.get_global_transform()
			var test_position:Vector2 = on_screen_position.origin
			var rotation_deviation = 100-accuracy
			rotation_deviation = rotation_deviation/2
			var deviation_degrees = randi_range(0,rotation_deviation)
			var rotate_direction = randi_range(0,1)
			if rotate_direction == 0: deviation_degrees = -deviation_degrees
			new_bullet.position = test_position
			new_bullet.presets(PhysicsBullet.preset_types.Only_Enemies)
			new_bullet.bullet_damage = scale_with_attribute_int(bullet_damage,owner.return_char_stats().speed_stat,attribute_damage_scale,attribute_point_scale)
			new_bullet.gravity_scale = 0.1
			var direction_vector:Vector2 = test_position.direction_to(target_pos).rotated(deg_to_rad(deviation_degrees))
			new_bullet.linear_velocity = projectile_speed * direction_vector
			scene_tree.current_scene.return_action_scene().add_child(new_bullet)
			await scene_tree.create_timer(burst_speed).timeout
		else: break
