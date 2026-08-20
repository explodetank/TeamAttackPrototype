extends Node2D

@onready var text_box = $Buffer/TextBox
@onready var step_speed:Timer = $StepSpeed
@onready var background:AnimatedSprite2D = $Buffer/BackgroundHolder/Background
@onready var event_handler = $Buffer/EventHandler
@onready var purple_fire_emitter = $Buffer/PurpleBulletPath

@export var idle_message_timer:Timer
@export var purple_fire_timer:Timer 

@export var paused = false
@export var hold_position = false
@export var step_speed_var = 0.125
@export var buffer_scene:Node

@onready var message_subsystem = $SillyMessageSubsystem

@export var initial_state:GameStates.states

signal state_changed(current_state)

var max_scenes:int
var current_steps:int = 0
var goal:int = 1500
var current_game_state:GameStates.states = initial_state

var idle_message_timer_min:float = 10.0
var idle_message_timer_max:float = 22.0

var steps_to_encounter_min:int = 25
var steps_to_encounter_max:int = 45
var steps_to_encounter = randi_range(steps_to_encounter_min,steps_to_encounter_max)

var steps_to_silly_text_min:int = 8
var steps_to_silly_text_max:int = 30

var steps_to_silly_text:int = randi_range(steps_to_silly_text_min,steps_to_silly_text_max)

func return_action_scene() -> Node:
	return buffer_scene

func pause_game():
	pass
	
func hold_place(current_state:bool):
	hold_position = current_state
	if hold_position:
		hold_position = true
		match current_game_state:
			GameStates.states.Descending:
				message_link(MessageEnum.Important,"You tell the adventures to take a breather.",false)
			GameStates.states.Combat:
				message_link(MessageEnum.System_Important,"Adventures won't descend after battle.",false)
		step_speed.stop()
	else: 
		match current_game_state:
			GameStates.states.Descending:
				message_link(MessageEnum.Important,"You tell the adventures to resume their descent.",false)
			GameStates.states.Combat:
				message_link(MessageEnum.System_Important,"Adventures will descend after battle.",false)
		hold_position = false
		if (current_game_state == GameStates.states.Descending): step_speed.start(step_speed_var)

func switch_state(new_state:GameStates.states):
	match new_state:
		GameStates.states.Descending:
			if (hold_position): new_state = GameStates.states.Idle
	print(new_state)
	current_game_state = new_state
	state_changed.emit(new_state)
	

func message_link(message_type,message_text:String,keep_border:bool):
	text_box.create_message(message_type,message_text,keep_border)

func _ready() -> void:
	text_box.change_steps(current_steps)
	step_speed.start(0.5)
	max_scenes = background.sprite_frames.get_frame_count("ZoneAnimation")
	message_link(MessageEnum.Thought,"You start your descent to the core...",false)
	purple_fire_timer.timeout.connect(purple_fire_emitter.spawn_fire)

func _on_step_speed_timeout() -> void:
	
	if background.frame < max_scenes-1:
		background.frame += 1
	else: background.frame = 0
	
	current_steps += 1
	text_box.change_steps(current_steps)
	
	if steps_to_silly_text <= 0:
		message_subsystem.create_silly_text()
		steps_to_silly_text = randi_range(steps_to_silly_text_min,steps_to_silly_text_max)
	else: steps_to_silly_text -= 1
	
	if steps_to_encounter <= 0: 
		await event_handler.roll_event()
		steps_to_encounter = randi_range(steps_to_encounter_min,steps_to_encounter_max)
	else: steps_to_encounter -= 1
		
	
	if current_steps < goal and not hold_position:
		step_speed.start(step_speed_var)
