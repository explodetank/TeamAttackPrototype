extends Path2D

@onready var spawn_path = $PurpleSpawnPath
var fire_bullet_scene = preload("res://Scenes/BulletDictionary/bullet_particle_1.tscn")

func spawn_fire():
	var new_bullet:PhysicsBullet = fire_bullet_scene.instantiate()
	spawn_path.progress_ratio = randf()
	new_bullet.position = spawn_path.position + Vector2(0,-80)
	
	var bullet_data:BulletData = new_bullet.bullet_data
	bullet_data.destroy_on_collide = true
	bullet_data.destroy_off_screen = true
	get_tree().current_scene.add_child(new_bullet)
