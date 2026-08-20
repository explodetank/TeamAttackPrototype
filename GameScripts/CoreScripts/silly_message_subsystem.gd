extends Node

var silly_dungeon_text = [
	"walks through a puddle.", "trips!","blinks.",
	"feels sleepy...","wants to eat something.","wants a coffee break.",
	"hums a tune.","shivers.","wants to take a break.","stumbles but catches themselves!",
	"kicks a rock!","stares at the ceiling for a bit.","wants something to drink.","lights a match."
]

var silly_dungeon_text_duo = ["banters with {0}.","gossips with {0}.","talks with {0}."]

var silly_idle_text = ["sits down for a little.","creates a cozy campfire!","takes a nap.","eats a snack.",
"dreams about the surface.","feels chilly.","stares at the wall."]

var main_game_node:Node2D

func create_silly_text():
	var get_player_group:Array[Node] = get_tree().get_nodes_in_group("PartyMembers")
	if get_player_group.size() > 0:
		var get_random_member = get_player_group.pick_random()
		var return_index:int = get_player_group.find(get_random_member);get_player_group.pop_at(return_index)
		var get_member_info:PlayerAttributes = get_random_member.return_char_stats()
		
		var message_type:String
		var rng_text = randi_range(0,4)
		if rng_text == 4 and get_player_group.size() > 0:
			var get_random_member_2 = get_player_group.pick_random()
			var get_member_info_2:PlayerAttributes = get_random_member_2.return_char_stats()
			message_type = get_random_member.internal_name + " "+silly_dungeon_text_duo.pick_random().format([get_random_member_2.internal_name])
		else:
			message_type = get_random_member.internal_name + " "+silly_dungeon_text.pick_random()
		main_game_node.message_link(MessageEnum.Thought,message_type,false)

func create_idle_text():
	pass

func _ready() -> void:
	main_game_node = get_tree().current_scene
	#await get_tree().create_timer(1).timeout
	#create_silly_text()
