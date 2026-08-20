class_name WeaponResource extends Resource

@export var weapon_name:String = ""
@export var weapon_base_category:PlayerAttributes.AttributeTypes
@export var weapon_description:String

# Primary on cooldown is there in case I decide to change something related to
# the ai node.
@export var secondary_on_cooldown:bool = false
@export var primary_on_cooldown:bool = false

@export var min_attack_speed:float = 1.0
@export var max_attack_speed:float = 2.0

@export var min_secondary_recharge:float = 6.0
@export var max_secondary_recharge:float = 10.0

@export var primary_attack:WeaponAttack
@export var secondary_attack:WeaponAttack

var cooldown_timer:SceneTreeTimer

## Function to handle generating random recharge values for the secondary ability.
func random_secondary_cooldown() -> float:
	return randf_range(min_secondary_recharge,max_secondary_recharge)

## Disables the cooldown for the secondary.
func finish_secondary_cooldown() -> void:
	secondary_on_cooldown = false
	remove_timer()

## Removes the timer and ensures that it's disconnected from the finish secondary cooldown function.
func remove_timer() -> void:
	if cooldown_timer:
		if cooldown_timer.timeout.is_connected(finish_secondary_cooldown): cooldown_timer.timeout.disconnect(finish_secondary_cooldown)
		cooldown_timer = null

## Starts the timer.
func start_timer(tree_scene:SceneTree) -> void:
	cooldown_timer = tree_scene.create_timer(random_secondary_cooldown())
	cooldown_timer.timeout.connect(finish_secondary_cooldown)

## Check if the primary ability exists, even though it probably will always exist.
func has_primary() -> bool:
	if primary_attack: return true
	return false

## Check if the secondary ability exists.
func has_secondary() -> bool:
	if secondary_attack: return true
	return false

## Check if the secondary ability is on cooldown.
func can_use_secondary() -> bool:
	return not secondary_on_cooldown

## Start the secondary ability cooldown. Can also be used to refresh the cooldown.
func start_secondary_cooldown(tree_scene:SceneTree) -> void:
	secondary_on_cooldown = true
	remove_timer()
	start_timer(tree_scene)
	
# @export var weapon_level:int = 0
# @export var max_level:int = 10

# @export var base_damage:int = 2

# @export var base_secondary_cooldown:float = 10.0
# @export var can_use_secondary:bool = true
