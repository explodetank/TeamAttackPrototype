extends CollisionShape2D

@export var parent_node:PhysicsBullet

func _ready() -> void:
	if parent_node.rotate_with_velocity:
		self.rotation = parent_node.linear_velocity.angle() + deg_to_rad(parent_node.rotate_velocity)

func _physics_process(delta: float) -> void:
	if parent_node.rotate_with_velocity:
		self.rotation = parent_node.linear_velocity.angle() + deg_to_rad(parent_node.rotate_velocity)
