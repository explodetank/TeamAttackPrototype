extends Area2D
class_name HitboxComponent

@export var health_component:HealthComponent
@export var hitbox_link:CollisionShape2D
@export var parent_groups:PackedStringArray

@export var parent_node:Node

func set_parent_groups(new_parent_groups:PackedStringArray):
	parent_groups = new_parent_groups

func take_damage(damage:int):
	health_component.take_damage(damage)
	
func heal_character(amount:int):
	health_component.heal(amount)
	
func entered_node(node:Node2D):
	if node is PhysicsBullet:
		var send_over:Node = self
		if parent_node:
			send_over = parent_node
		node.run_collision_code(send_over)
		var damage = node.bullet_damage
		if damage != 0: health_component.take_damage(damage)
		
func _ready() -> void:
	self.monitoring = true
	if hitbox_link:
		# If there is a CollisionShape2D assigned to this component, then make a 
		# signal and function to detect any rigid 2d bodies.
		self.body_entered.connect(entered_node)
		pass
