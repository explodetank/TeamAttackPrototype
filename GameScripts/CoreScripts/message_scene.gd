extends Control

@onready var message_text:RichTextLabel = $MessageText
@onready var border_sprite:AnimatedSprite2D = $BorderSprite
@onready var message_icon:Sprite2D = $BorderSprite/MessageIcon

var thought_icon = preload("res://Textures/MessageIcons/Sprite-SpeakSprite.png")
var fight_icon = preload("res://Textures/MessageIcons/Sprite-FightIcon.png")
var important_icon = preload("res://Textures/MessageIcons/Sprite-DefeatIcon.png")
var system_important_icon = preload("res://Textures/MessageIcons/Sprite-Important2Icon.png")

var text_speed = 0.0025

func play_border_sprite(leave_border:bool):
	for i in range(3):
		border_sprite.play("default",1.0,false)
		await border_sprite.animation_finished
	if not leave_border:
		border_sprite.frame = 0

func add_message(message_type,text:String,leave_border:bool):
	var message_color:Color = Color(108.821, 108.821, 108.821, 1.0)
	var new_texture:Texture2D
	var tween_object = get_tree().create_tween()
	var save_pos = border_sprite.position
	var start_pos = border_sprite.position - Vector2(750,0)
	
	border_sprite.position = start_pos
	
	match message_type:
		
		MessageEnum.Thought:
			new_texture = thought_icon
		
		MessageEnum.Fight:
			new_texture = fight_icon
			message_color = Color(1.0, 0.0, 0.0, 1.0)
		
		MessageEnum.Important:
			new_texture = important_icon
			message_color = Color(1.0, 1.0, 0.0, 1.0)
		
		MessageEnum.System_Important:
			new_texture = system_important_icon
			message_color = Color(1.0, 1.0, 0.0, 1.0)
		
		MessageEnum.Member_Attack:
			new_texture = fight_icon
			
	tween_object.tween_property(border_sprite,"position",save_pos,0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	message_text.text = text
	message_text.self_modulate = message_color
	message_text.visible_characters = 0
	border_sprite.self_modulate = message_color
	message_icon.self_modulate = message_color
	message_icon.texture = new_texture
	
	play_border_sprite(leave_border)
	tween_object.play()
	await tween_object.finished
	
	var elapsed_time = 0
	var message_length = text.length()
	for i in range(message_length+1):
		message_text.visible_characters = i
		while (elapsed_time < text_speed):
			self.get_process_delta_time()
			await get_tree().process_frame
			elapsed_time += self.get_process_delta_time()
		elapsed_time -= text_speed
	
