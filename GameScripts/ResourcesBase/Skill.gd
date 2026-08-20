class_name Skill extends Resource
## Skills work differently than weapons in that they're meant to be attached to the character directly.

@export var skill_name:String
@export var skill_type:PlayerAttributes.AttributeTypes
@export var skill_description:String

@export var skill_level:int
@export var skill_level_max:int

@export var skill_cooldown:float
@export var resource_cost:int

@export var skill_resource:MoveResource:
	set(value):
		skill_resource = value

enum cooldown_types {Cooldown,Resources,Misc,None}

@export var cooldown_type:cooldown_types

var on_cooldown:bool = false
var cooldown_object:Timer
var skill_owner:Node

signal started_cooldown
signal recharged

var ignore_groups:Array[String]

# Method to check for a custom resource like magic.
func check_resources(compare_resource:int) -> bool:
	if compare_resource >= resource_cost:
		return true
	return false

# Hopefully this will fit every need I need.
# First need is that it needs to have an owner. Targets aren't particularly necessary.
# Needs to have incoming damage and needs to return a number for damage reducing skills (i.e block, parry, retaliate).

func set_skill_owner(owner:Node):
	skill_owner = owner

func timeout_function():
	on_cooldown = false
	recharged.emit()

func skip_cooldown():
	if cooldown_object && skill_owner:
		cooldown_object.stop()
		cooldown_object.timeout.emit()

func start_cooldown():
	# Check if anyone owns the skill.
	if skill_owner:
		on_cooldown = true
		# Check if the cooldown object exists. If not create a new one and parent it to the character.
		if not cooldown_object:
			cooldown_object = Timer.new()
			cooldown_object.one_shot = true
			cooldown_object.timeout.connect(timeout_function)
			skill_owner.add_child(cooldown_object)
			
		cooldown_object.wait_time = float(skill_cooldown)
		cooldown_object.start()
		started_cooldown.emit()

func can_use(current_resources:int) -> bool:
	match cooldown_type:
	
		cooldown_types.Resources:
			return check_resources(current_resources)
		
		cooldown_types.Cooldown:
			return on_cooldown
			
		cooldown_types.None: return true
	
	return false
