class_name SpecialEffectNode extends Sprite2D

#var tween_object:Tween = self.create_tween()
var tween_object:Tween = self.create_tween()
func _ready() -> void:
	#tween_object = get_tree().create_tween()
	pass

func reset():
	self.self_modulate = Color(255,255,255,1)
	self.scale = Vector2(1,1)
	self.rotation = 0
	if tween_object != null:
		tween_object.kill()
	tween_object = self.create_tween()

func force_store():
	if tween_object != null:
		tween_object.kill()
	SpecialEffectPool.store_object(self)
