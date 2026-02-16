class_name TutorialLevel extends Node

enum ObjectiveType {
	SPEED,
	SPEED_AND_DIRECTION,
	MAKE_ITEM
}

@export var objective_node: NodePath
@export var objective_type: ObjectiveType
@export var definition: Dictionary = {}

@export var label3d: Label3D

func _process(_delta: float) -> void:
	if not objective_node.is_empty() and objective_type >= 0:
		if objective_type == ObjectiveType.SPEED:
			if check_speed():
				label3d.text = "Congratulations!!"
		elif objective_type == ObjectiveType.SPEED_AND_DIRECTION:
			if check_speed(true):
				label3d.text = "Congratulations!!"
	pass

func check_speed(check_direction: bool = false) -> bool:
	var node = get_node(objective_node)
	for key in definition.keys():
		if key == "speed" and node is PowerNode:
			if node.get("speed") == definition[key] and not node.get("is_overstressed"):
				if check_direction and sign(node.get("speed")) != sign(definition[key]):
					return false
				print(name, ": objective accomplished")
				return true
	return false
