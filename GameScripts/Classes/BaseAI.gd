extends Node2D
class_name AttackAINode

signal attacking(target:Node2D,damage:int,message_override:String)

# Group to attack
@export var attack_group:String
@export var health_component:HealthComponent
@export var direct_attack_timer:Timer
@export var weapon_manager:WeaponManager
@export var controlled_entity:EntityCore

@export var attack_speed_min:float = 2.0
@export var attack_speed_max:float = 5.0

@export var can_attack = true

func update_attack_speed(new_min:float,new_max:float):
	attack_speed_max = new_max
	attack_speed_min = new_min

func primary_attack():
	if can_attack and not health_component.dead and attack_group:
		var parent = controlled_entity
		var damage = parent.base_damage
		var get_targets = get_tree().get_nodes_in_group(attack_group)
		if get_targets.size() > 0:
			var get_target = get_targets.pick_random()
			if parent is PartyMember:
				if weapon_manager.return_equipped_weapon():
					# The weapon will have it's own behavior.
					weapon_manager.primary_attack()
					weapon_manager.secondary_ability()
				else:
					get_target.take_damage(get_parent(),damage)
					attacking.emit(get_target,damage,"")
			else:
				#var get_target = get_targets.pick_random()
				get_target.take_damage(get_parent(),damage)
				attacking.emit(get_target,damage)
		else: pass

func _ready() -> void:
	while AttackAINode:
		var delay = randf_range(attack_speed_min,attack_speed_max)
		primary_attack()
		if get_parent() is PartyMember:
			if weapon_manager.return_equipped_weapon():
				delay = weapon_manager.return_random_attack_speed()
		await get_tree().create_timer(delay).timeout
	
