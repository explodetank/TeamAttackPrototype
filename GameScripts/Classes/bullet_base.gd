class_name PhysicsBullet extends RigidBody2D

signal hit_target
signal destroy
signal collide(node:Node2D,hit_pos:Vector2)

var velocity_tween:Tween

enum preset_types {Only_PartyMembers,Only_Enemies,Both,None}

@export var sprite_array:Array[Node]
@export var particle_array:Array[GPUParticles2D]
@export var destroy_particles:Array[SpecialEffectsUtil.SpecialEffects]

@export var lifetime_timer:Timer
@export var on_screen_object:VisibleOnScreenNotifier2D

@export var rotate_with_velocity:bool = false
@export var rotate_velocity:float = 0.0

@export var particle_start_delay:float = 0.0
@export var bullet_damage:int = 0

var destroying:bool = false

@export var bullet_data:BulletData:
	set(value):
		bullet_data = value

# I'm too lazy to keep making these presets.
func presets(preset:preset_types):
	match preset:
		preset_types.Only_PartyMembers:
			self.set_collision_layer_value(4,true)
			self.set_collision_layer_value(3,false)
		preset_types.Only_Enemies:
			self.set_collision_layer_value(4,false)
			self.set_collision_layer_value(3,true)
		preset_types.Both:
			self.set_collision_layer_value(4,true)
			self.set_collision_layer_value(3,true)
		preset_types.None:
			self.set_collision_layer_value(4,false)
			self.set_collision_layer_value(3,false)

func tween_velocity(new_tween:Tween):
	if velocity_tween:
		velocity_tween.kill()
	velocity_tween = new_tween
	new_tween.play()

func run_collision_code(object_node:Node):
	for effect_enum in destroy_particles:
		SpecialEffectsUtil.play_effect(effect_enum,position,get_tree().current_scene)
	collide.emit(object_node,position)
	if bullet_data.destroy_on_collide:
		destroy_bullet()

func run_collision_check(node:Node2D):
	pass

func run_timer():
	lifetime_timer.wait_time = bullet_data.bullet_lifetime

func destroy_bullet():
	destroying = true
	destroy.emit()
	self.presets(preset_types.None)
	self.set_sleeping(true)
	var longest_particle_duration:GPUParticles2D
	#self.linear_velocity = Vector2(0,0)
	for sprite in sprite_array:
		sprite.visible = false
	for particles in particle_array:
		if not longest_particle_duration:
			longest_particle_duration = particles
		elif (longest_particle_duration.lifetime < particles.lifetime): longest_particle_duration = particles
	
	if longest_particle_duration:
		longest_particle_duration.emitting = false
		await get_tree().create_timer(longest_particle_duration.lifetime).timeout
	
	if bullet_data.destroy_delay > 0.0:
		await get_tree().create_timer(bullet_data.destroy_delay).timeout
		
	self.queue_free()

# Note to self: When the object is instantiated and ready, run code
func _ready() -> void:
	if not bullet_data:
		bullet_data = BulletData.new()
	
	if bullet_data.return_destroy_off_screen():
		on_screen_object.screen_exited.connect(destroy_bullet)
	
	if particle_start_delay > 0.0:
		await get_tree().create_timer(particle_start_delay).timeout
	
	if not destroying:
		for particle in particle_array:
			particle.emitting = true

func add_group(group_name:String):
	add_to_group(group_name,false)
	pass

func return_bullet_data() -> BulletData:
	if not bullet_data:
		bullet_data = BulletData.new()
	return bullet_data

func return_destroy_on_collide() -> bool:
	return bullet_data.destroy_on_collide

func return_self() -> PhysicsBullet:
	return self
