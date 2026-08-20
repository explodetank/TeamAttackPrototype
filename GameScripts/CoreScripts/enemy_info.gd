extends ColorRect

@onready var buffer:Panel = $Buffer
@onready var shake_node:ShakeNode = buffer.get_node("ShakeNode")
@onready var hp_text:RichTextLabel = buffer.get_node("HP")
@onready var hp_bar:ProgressBar = buffer.get_node("HPBar")
@onready var enemy_name:RichTextLabel = buffer.get_node("EnemyName")

var currrent_hp_component:HealthComponent

var healthy_color = Color(0.093, 0.743, 1.0, 1.0)
var damaged_color = Color(1.0, 0.939, 0.014, 1.0)
var critical_color = Color(1.0, 0.133, 0.0, 1.0)

func return_self() -> Variant:
	return self

func erase_self():
	currrent_hp_component.health_changed.disconnect(damaged)
	currrent_hp_component.died.disconnect(erase_self)
	self.queue_free()
	
func damaged(current_health:int,old_health:int):
	if current_health < old_health:
		shake_node.shake(0.15)
	hp_text.text = "HP: "+str(current_health)+"/"+str(currrent_hp_component.max_health)
	hp_bar.value = current_health
	var get_percent = float(current_health)/float(currrent_hp_component.max_health)
	
	if (get_percent > 0.65): hp_bar.self_modulate = healthy_color
	elif (get_percent <= 0.65 && get_percent > 0.33): hp_bar.self_modulate = damaged_color
	else: hp_bar.self_modulate = critical_color

func link_target(enemy_node:Node):
	if not enemy_node.is_node_ready():
		await enemy_node.ready
	enemy_name.text = enemy_node.return_name()
	currrent_hp_component = enemy_node.get_node("HealthComponent")
	if currrent_hp_component.is_ready == false:
		await currrent_hp_component.component_ready
	currrent_hp_component.died.connect(erase_self)
	currrent_hp_component.health_changed.connect(damaged)
	hp_bar.max_value = currrent_hp_component.max_health
	hp_bar.value = currrent_hp_component.health
	damaged(currrent_hp_component.health,currrent_hp_component.health)
	
