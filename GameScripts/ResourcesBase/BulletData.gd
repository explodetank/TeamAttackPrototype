class_name BulletData extends Resource

@export var bullet_damage:int
@export var target_groups:PackedStringArray = []

@export var destroy_on_collide:bool = true
@export var destroy_off_screen:bool = true

@export var destroy_delay:float = 0.0
@export var bullet_lifetime:float = 0.0

enum collision_types {Blacklist,Whitelist}

@export var collision_type:collision_types

func change_collision_type(collide_type:collision_types):
	collision_type = collide_type

func return_target_groups() -> PackedStringArray:
	return target_groups

func return_destroy_off_screen():
	return destroy_off_screen
