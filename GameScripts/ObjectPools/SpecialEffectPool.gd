class_name SpecialEffectPool

static var stored_scenes = []
static var all_scenes = []

static func store_object(object:SpecialEffectNode):
	object.position = Vector2(2000,0)
	stored_scenes.append(object)
	
static func get_object() -> SpecialEffectNode:
	var get_effect = stored_scenes.pop_back()
	if not get_effect:
		get_effect = SpecialEffectNode.new()
		all_scenes.append(get_effect)
	get_effect.reset()
	return get_effect

static func free_objects():
	for i in all_scenes:
		i.queue_free()
	stored_scenes = []
	all_scenes = []
