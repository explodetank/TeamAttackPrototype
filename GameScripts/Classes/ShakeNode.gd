extends Node
class_name ShakeNode

var shake_count:float = 0.0
@export var shake_intensity:float = 5.0

var original_rotation:float
var original_position:Vector2

var rotation_tween:Tween

var currentParent:Variant
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentParent = get_parent()
	update_position()
	update_rotation()

func rotate_shake(rotate:float,duration:float):
	if rotation_tween:
		rotation_tween.kill()
	
	rotation_tween = currentParent.create_tween()
	currentParent.rotation = rotate
	
	rotation_tween.tween_property(currentParent,"rotation",original_rotation,duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	rotation_tween.play()

func update_rotation():
	original_rotation = currentParent.rotation

func update_position():
	original_position = currentParent.position

func shake(shake_duration:float):
	shake_count = shake_duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_count > 0:
		shake_count = clamp(shake_count-delta,0,shake_count)
		var random_rotation = randf() * 2 * PI
		var offset_vector = Vector2.from_angle(random_rotation) * shake_intensity * shake_count
		currentParent.position = original_position + offset_vector
		
