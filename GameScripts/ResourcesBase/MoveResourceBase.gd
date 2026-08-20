@abstract class_name MoveResource extends Resource
## The base class for different types of moves, like defensive or offensive/support.
## Not meant to be used directly but to generate different move resource classes.

# How to use:
# start_value: The base value to add/subtract from.
# attribute_points: Character or Enemy attribute to scale from.
# value_scale: How many attribute points it takes to scale the value
# value_increment: The value that's added/subtracted from the value
func scale_with_attribute_int(start_value:int,attribute_points:int,value_scale:int,value_increment:int) -> int:
	var modify_value = start_value
	while (attribute_points > value_scale):
		attribute_points -= value_scale
		modify_value += value_increment
	return modify_value

func scale_with_attribute_float(start_value:float,attribute_points:float,value_scale:float,value_increment:float) -> float:
	var modify_value = start_value
	while (attribute_points > value_scale):
		attribute_points -= value_scale
		modify_value += value_increment
	return modify_value

@abstract func level_up(new_level:int) -> void
