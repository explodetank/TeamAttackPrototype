class_name Enemy extends ActiveEntity

@onready var shake_node:ShakeNode = $ShakeNode

@export var resource:EntityAttributes:
	set(value):
		resource = value
		
func return_self() -> Variant:
	return self

func change_name(new_name:String):
	resource.internal_name = new_name

# Don't know if I'm going to be using an internal name or if the scene nodes name is enough.
func return_name() -> String:
	return resource.internal_name

func take_damage(dealer:Node,damage:int):
	if health_component:
		health_component.take_damage(damage)

func start_stats() -> void:
	pass

func _ready() -> void:
	health_component = $HealthComponent
	health_component.died.connect(died)

func died():
	await get_tree().create_timer(0.005).timeout
	SpecialEffectsUtil.play_effect(SpecialEffectsUtil.SpecialEffects.Aura_1,self.position,get_tree().current_scene)
	var defeated_message = resource.internal_name + " falls in defeat!"
	get_tree().current_scene.message_link(MessageEnum.Important,defeated_message,false)
	self.queue_free()

func _on_health_component_health_changed(current_health: Variant, old_health: Variant) -> void:
	if current_health < old_health:
		var animated_sprite = $Sprite
		var frames = animated_sprite.sprite_frames
		var get_texture:Texture2D = frames.get_frame_texture(animated_sprite.animation,animated_sprite.frame)
		var get_size = get_texture.get_size()
		var rng_x = randi_range(-get_size.x/2,get_size.x/2)
		var rng_y = randi_range(-get_size.y/2,get_size.y/2)
		SpecialEffectsUtil.play_effect(SpecialEffectsUtil.SpecialEffects.Small_Hit_1,position + Vector2(rng_x,rng_y),get_tree().current_scene)
		var rotation_dir = randi_range(0,1)
		match rotation_dir:
			1: rotation_dir = -rotation_dir
			0: rotation_dir = 1
		var random_deg = randi_range(7,10)
		shake_node.rotate_shake(deg_to_rad(random_deg * rotation_dir),0.2)
		shake_node.shake(0.13)
		
