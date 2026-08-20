extends Panel

@onready var message_scene = preload("res://Scenes/message_scene.tscn")
@onready var dialog_container = $DialogContainer
@onready var steps = $Steps

var max_history = 7

func change_steps(new_steps:int):
	steps.text = "Steps: " + str(new_steps)
	
func create_message(message_type,text:String,keep_border:bool):
	var new_message = message_scene.instantiate()
	dialog_container.add_child(new_message)
	dialog_container.move_child(new_message,0)
	new_message.add_message(message_type,text,keep_border)
	var get_textboxes = dialog_container.get_children()
	var grab_size = get_textboxes.size()
	if grab_size > max_history:
		var over_amount = grab_size - max_history
		for i in range(over_amount):
			dialog_container.get_child(7).queue_free()
	
