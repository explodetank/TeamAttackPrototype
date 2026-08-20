extends Timer

@export var get_sprite1:Sprite2D
@export var get_sprite2:Sprite2D

var test_bool:bool = false

var save_scale1:Vector2
var save_scale2:Vector2

func change_appearance():
	test_bool = not test_bool
	if test_bool:
		get_sprite1.scale -= Vector2(0.4,0.4)
		get_sprite2.scale += Vector2(0.3,0.3)
	else:
		get_sprite1.scale = save_scale1
		get_sprite2.scale = save_scale2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_scale1 = get_sprite1.scale
	save_scale2 = get_sprite2.scale
	self.timeout.connect(change_appearance)
	self.start()
