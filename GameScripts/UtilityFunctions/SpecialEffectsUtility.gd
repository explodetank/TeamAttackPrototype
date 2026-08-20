class_name SpecialEffectsUtil

enum SpecialEffects {Small_Hit_1,Aura_1,ParticleSplash_1}

static var small_hit_textures = [preload("res://Textures/SpecialEffects/Sprite-SmallHit1.png"),preload("res://Textures/SpecialEffects/Sprite-SmallHit2.png")]
static var purple_splash_scene = preload("res://Scenes/ParticleScenes/purplesplashscene.tscn")

static func play_effect(effect_type,position:Vector2,parent:Node):
	match effect_type:
		
		SpecialEffects.Small_Hit_1:
			
			var get_effect:SpecialEffectNode = SpecialEffectPool.get_object()
			var tween_object = get_effect.tween_object
			
			get_effect.rotation = randf() * deg_to_rad(359.0)
			get_effect.position = position
			get_effect.texture = small_hit_textures.pick_random()
			
			var rng_size = randf_range(2.5,3.0)
			get_effect.scale = Vector2(rng_size,rng_size)
			
			#tween_object.tween_property(get_effect,"scale",Vector2(rng_size,rng_size),0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
			tween_object.tween_property(get_effect,"self_modulate",Color(255,255,255,0),0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).set_delay(0.075)
			tween_object.tween_callback(get_effect.force_store)
			tween_object.play()
			
			if not get_effect.is_inside_tree():
				parent.add_child(get_effect)
		SpecialEffects.Aura_1:
			var get_effect:SpecialEffectNode = SpecialEffectPool.get_object()
			var tween_object = get_effect.tween_object
			
			get_effect.rotation = randf() * deg_to_rad(359.0)
			get_effect.position = position
			get_effect.texture = load("res://Textures/SpecialEffects/Sprite-Aura1.png")
			get_effect.scale = Vector2(0.5,0.5)
			
			var rng_scale = randf_range(6.0,8.0)
			
			if not get_effect.is_inside_tree():
				parent.add_child(get_effect)
			
			tween_object.tween_property(get_effect,"rotation",get_effect.rotation - deg_to_rad(-720),1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_object.parallel().tween_property(get_effect,"scale",Vector2(rng_scale,rng_scale),0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_object.parallel().tween_property(get_effect,"self_modulate",Color(1.0, 1.0, 1.0, 0.0),0.7).set_delay(0.9).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
			tween_object.tween_callback(get_effect.force_store)
			
			tween_object.play()
		SpecialEffects.ParticleSplash_1:
			var get_particle:GPUParticles2D = purple_splash_scene.instantiate()
			get_particle.position = position
			parent.add_child(get_particle)
			get_particle.emitting = true
			await get_particle.finished
			get_particle.queue_free()
