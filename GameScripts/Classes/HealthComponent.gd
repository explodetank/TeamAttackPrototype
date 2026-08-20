extends Node2D
class_name HealthComponent

signal health_changed(current_health,old_health)
signal component_ready()
signal died

@export var max_health:int = 100
@export var invincible = false

var dead = false
var health = max_health
var is_ready:bool = false

func _ready() -> void:
	health = max_health
	is_ready = true
	component_ready.emit()

# Returns a boolean to indicate damage
func take_damage(damage:int) -> bool:
	if not invincible and not dead:
		var old_health = health
		health = clamp(health - damage, 0,max_health)
		health_changed.emit(health,old_health)
		if health == 0:
			dead = true
			died.emit()
		return true
	return false

func heal(heal_amount:int):
	var old_health = health
	health = clamp(health + heal_amount,0,max_health)
	health_changed.emit(health,old_health)
