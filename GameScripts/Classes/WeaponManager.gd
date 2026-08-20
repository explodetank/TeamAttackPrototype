class_name WeaponManager extends Node
## Handles different kinds of weapon types?
## Might switch what this class extends from later.

@export var damage:int = 10
@export var secondary_cooldown:float = 12.0

@export var primary_stat:PlayerAttributes.AttributeTypes

@export var weapon_owner:EntityCore
@export var fire_node:Node

@export var current_level:int = 0
@export var max_level:int = 0

@export var weapon_resource:WeaponResource:
	set(value):
		weapon_resource = value
#@abstract func secondary_ability(targets:Array[Node])
#@abstract func primary_attack(targets:Array[Node])
#@abstract func level_up()
#@abstract func start_stats()

## Basically initializes the weapon values. 
func start_weapons():
	if weapon_resource and weapon_owner:
		# Only contains this but this function might be important when obtaining new weapons?
		level_up()

## Switch weapons. Auto duplicates the weapon.
func switch_weapons_duplicate(new_weapon:WeaponResource):
	weapon_resource = new_weapon.duplicate(true)
	start_weapons()

## Switch weapons but without duplicating the weapon.
func switch_weapons(new_weapon:WeaponResource):
	weapon_resource = new_weapon
	start_weapons()

## Triggers the primary attack of the weapon assuming there is a primary attack attached.
func primary_attack():
	if weapon_owner and weapon_resource and weapon_resource.has_primary():
		weapon_resource.primary_attack.trigger(weapon_owner,fire_node,get_tree())
	
## Triggers the secondary attack of the weapon assuming there is a secondary attack.
func secondary_ability():
	if weapon_owner and weapon_resource and weapon_resource.has_secondary() and weapon_resource.can_use_secondary():
		weapon_resource.secondary_attack.trigger(weapon_owner,fire_node,get_tree())
		get_tree().current_scene.message_link(MessageEnum.Member_Attack,weapon_owner.internal_name + " uses "+weapon_resource.weapon_name+"!",false)
		weapon_resource.start_secondary_cooldown(get_tree())

## Level up function. Also acts as a way to initialize the weapons stats.
func level_up():
	if weapon_resource:
		if weapon_resource.has_primary(): weapon_resource.primary_attack.level_up(current_level)
		if weapon_resource.has_secondary(): weapon_resource.secondary_attack.level_up(current_level)

## Return the currently equipped weapon.
func return_equipped_weapon() -> WeaponResource:
	return weapon_resource

## Generates a random attack speed value based on the weapon.
func return_random_attack_speed() -> float:
	return randf_range(weapon_resource.min_attack_speed,weapon_resource.max_attack_speed)

## Sets the owner.
func set_weapon_owner(new_owner:Node):
	weapon_owner = new_owner


func _ready() -> void:
	if weapon_resource:
		weapon_resource = weapon_resource.duplicate(true)
		start_weapons()
		
