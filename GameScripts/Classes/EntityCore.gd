@abstract
class_name EntityCore extends Control

@export var health_component:HealthComponent
@export var hitbox_component:HitboxComponent
@export var internal_name:String

@export var char_resource:EntityAttributes:
	set(value):
		char_resource = value

@abstract func take_damage(damage_dealer:Node,damage:int) -> bool
@abstract func return_name() -> String
@abstract func died()
@abstract func start_stats() -> void

func add_entity_to_group(group_name:String):
	self.add_to_group(group_name)

## Returns the character stats.
func return_char_stats() -> EntityAttributes:
	return char_resource
	
