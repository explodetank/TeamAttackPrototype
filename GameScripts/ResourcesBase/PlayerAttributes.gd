class_name PlayerAttributes extends EntityAttributes

signal xp_gained
signal leveled_up

enum class_types {Gardener,Knight,Mage,Rogue}

@export var primary_attribute:AttributeTypes
@export var class_type:class_types

@export var starter_health:int = 75
@export var health_scale:int = 20

# If the party member has no weapons, it relies on this instead.
@export var base_damage_scale:int = 2
@export var base_damage:int = 7

@export var xp_requirement_scale:int = 50
@export var current_xp:int = 0
@export var max_xp:int = 200
@export var current_level:int = 0

@export var current_weapon:WeaponResource:
	set(value):
		current_weapon = value

@export var support_skills:Dictionary[AttributeTypes,Array] = {
	AttributeTypes.Strength:[],
	AttributeTypes.Magic:[],
	AttributeTypes.Speed:[],
	AttributeTypes.Vitality:[]
}

@export var battle_skills:Dictionary[AttributeTypes,Array] = {
	AttributeTypes.Strength:[],
	AttributeTypes.Magic:[],
	AttributeTypes.Speed:[],
	AttributeTypes.Vitality:[]
}

@export var on_hit_skills:Array[Skill] = []

func add_xp(xp_amount:int):
	current_xp += xp_amount
	# Theoretically shouldn't run if this condition is false.
	if (current_xp > max_xp):
		while (current_xp > max_xp):
			current_level += 1
			current_xp -= max_xp
			max_xp += xp_requirement_scale
		leveled_up.emit() # Leveling up will automatically trigger the xp_gained function.
	else: xp_gained.emit() # Trigger this instead if the character isn't leveling up.
