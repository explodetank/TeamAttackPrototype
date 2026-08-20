extends Control

@onready var enemy_spawn = $EnemySpawn/SpawnPath
@onready var enemy_info_bar = $EnemyInformation
@onready var encounter_timer = $EncounterTimer

var enemy_info = load("res://Scenes/BaseScenes/EnemyInfo.tscn")
var enemy_types = [load("res://Scenes/EnemyFolder/SentryBot.tscn"),load("res://Scenes/EnemyFolder/AncientCore.tscn")]
var max_enemies = 6
var main_game:Node2D

var encounter_messages_group = ["A group of enemies stand in your way!","A band of enemies block your path!"]
var encounter_messages_single = ["A lone enemy impedes your descent!","A single enemy blocks your way!"]

func spawn_enemy() -> bool:
	var get_enemies = get_tree().get_nodes_in_group("Enemy")
	if get_enemies.size() < max_enemies:
		
		var get_enemy = enemy_types[randi_range(0,enemy_types.size()-1)].instantiate()
		var enemy_info = enemy_info.instantiate()
		
		enemy_spawn.progress_ratio = randf()
		get_enemy.position = enemy_spawn.position
		add_child(get_enemy)
		enemy_info_bar.add_child(enemy_info)
		enemy_info.link_target(get_enemy.return_self())
		return true
	return false
	
func enemy_encounter() -> bool:
	main_game.switch_state(GameStates.states.Combat)
	var enemy_spawns = randi_range(1,3)
	var get_message
	if enemy_spawns == 1:
		get_message = encounter_messages_single.pick_random()
	else: get_message = encounter_messages_group.pick_random()
	get_tree().current_scene.message_link(MessageEnum.Fight,get_message,false)
	
	for i in range(enemy_spawns):
		spawn_enemy()
		
	while (get_tree().get_nodes_in_group("Enemy").size() > 0):
		encounter_timer.start()
		await encounter_timer.timeout
	#if main_game.hold_position:
	#	main_game.switch_state(GameStates.states.Idle)
	#else:
	#	main_game.switch_state(GameStates.states.Descending)
	main_game.switch_state(GameStates.states.Descending)
	return true
	
	
func _ready() -> void:
	main_game = get_tree().current_scene
	#await get_tree().create_timer(1).timeout
	#for i in range(1):
	#	spawn_enemy()
	
func roll_event() -> bool:
	await enemy_encounter()
	
	return true
