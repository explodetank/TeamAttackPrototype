extends Button

@onready var parent_scene:Node2D
@onready var pause_icon:Sprite2D = $PauseIcon

var move_texture = preload("res://Textures/GeneralIcons/Sprite-MoveIcon.png")
var pause_texture = preload("res://Textures/GeneralIcons/Sprite-PauseIcon2.png")

func update_visual(on:bool):
	match on:
		true:
			pause_icon.texture = pause_texture
		false:
			pause_icon.texture = move_texture

func _toggled(toggled_on: bool) -> void:
	parent_scene.hold_position = toggled_on
	update_visual(toggled_on)
	parent_scene.hold_place(toggled_on)

func _ready() -> void:
	parent_scene = get_tree().current_scene
	update_visual(parent_scene.hold_position)
