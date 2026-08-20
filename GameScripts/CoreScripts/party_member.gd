class_name PartyMember extends ActiveEntity

# I probably should have this only control UI elements or expose variables for other scripts to use.
# That or get and set methods.
@export var defense_stat:RichTextLabel
@export var strength_stat:RichTextLabel
@export var speed_stat:RichTextLabel
@export var xp_bar:ProgressBar

@export var char_name_text:RichTextLabel
@export var char_level_text:RichTextLabel

@export var hp_text:RichTextLabel

@export var current_weapon:WeaponManager

#@export var char_resource:PlayerAttributes:
#	set(value):
#		char_resource = value

var on_cooldown_skills:Array[Skill] = []
var resource_store_skills:Array[Skill] = []

var xp_bar_tween:Tween
var level_up_tween:Tween

var current_level:int = 0
var current_xp:int = 0
var max_xp:int

func sort_resource_skills(skill_one:Skill,skill_two:Skill):
	if skill_one.resource_cost > skill_two.resource_cost:
		return false
	return true

func return_char_stats() -> PlayerAttributes:
	return char_resource

func return_name() -> String:
	return internal_name

func start_stats():
	defense_points = char_resource.defense_stat
	strength_points = char_resource.strength_stat
	vitality_points = char_resource.vitality_stat
	magic_points = char_resource.magic_stat
	max_xp = char_resource.max_xp
	
	base_damage = char_resource.base_damage
	#internal_name = char_resource.internal_name

func register_damage(current_health:int,old_health:int):
	hp_text.text = "HP:"+str(current_health)+"/"+str(health_component.max_health)

func add_xp(xp_amount:int):
	current_xp += xp_amount
	# Theoretically shouldn't run if this condition is false.
	if (current_xp > max_xp):
		while (current_xp > max_xp):
			current_level += 1
			current_xp -= max_xp
			max_xp += char_resource.xp_requirement_scale
		# leveled_up.emit() # Leveling up will automatically trigger the xp_gained function.
		update_char_level()
	else: update_xp_bar()

func update_char_level():
	if level_up_tween:
		level_up_tween.kill()
	level_up_tween = get_tree().create_tween()
	level_up_tween.tween_property(char_level_text,"self_modulate",Color(1.0, 0.852, 0.0, 1.0),0)
	level_up_tween.tween_interval(0.2)
	level_up_tween.tween_property(char_level_text,"self_modulate",Color(1.0, 1.0, 1.0, 1.0),0)
	level_up_tween.tween_interval(0.2)
	level_up_tween.set_loops(3)
	char_level_text.text = "LVL "+str(current_level)
	
	base_damage += char_resource.base_damage_scale
	health_component.max_health += char_resource.health_scale
	register_damage(health_component.health,health_component.health)
	
	update_stats()
	update_xp_bar()

func update_xp_bar():
	if xp_bar_tween: xp_bar_tween.kill()
	xp_bar_tween = get_tree().create_tween()
	xp_bar.max_value = max_xp
	xp_bar_tween.tween_property(xp_bar,"value",current_xp,0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	xp_bar_tween.play()

func update_stats():
	defense_stat.text = "DEF:"+str(defense_points)
	speed_stat.text = "SPD:"+str(speed_points)
	strength_stat.text = "STR:"+str(strength_points)

func take_damage(dealer:Node,damage:int) -> bool:
	
	return true

func died():
	pass

func _ready() -> void:
	start_stats()
	var get_group = self.get_groups()
	hitbox_component.set_parent_groups(get_group)
	health_component.health_changed.connect(register_damage)
	health_component.max_health = char_resource.starter_health
	health_component.health = health_component.max_health
	update_stats()
	register_damage(health_component.health,health_component.health)
	char_name_text.text = internal_name
	char_resource.xp_gained.connect(update_stats)
	char_resource.leveled_up.connect(update_char_level)
	
	
