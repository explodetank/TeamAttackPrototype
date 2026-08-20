@abstract class_name WeaponAttack extends MoveResource
## Abstract class for designing skills that target entities.

@abstract func trigger(owner:EntityCore,fire_node:Node,scene_tree:SceneTree) -> void
@abstract func level_up(new_level:int) -> void
