extends Resource
class_name EntityAttributes

enum AttributeTypes {Strength,Magic,Speed,Vitality}

@export var internal_name:String = ""

@export var strength_stat:int = 0
@export var magic_stat:int = 0
@export var speed_stat:int = 0
@export var vitality_stat:int = 0

@export var defense_stat:int = 0
@export var base_attack:int = 5
@export var attack_speed_min:float = 3
@export var attack_speed_max:float = 5
