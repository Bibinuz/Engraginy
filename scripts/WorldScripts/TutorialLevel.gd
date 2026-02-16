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

var wining_message: String = "Felicitats objectiu complert!"

func _process(_delta: float) -> void:
	if not objective_node.is_empty() and objective_type >= 0:
		if objective_type == ObjectiveType.SPEED:
			if check_speed():
				label3d.text = wining_message
		elif objective_type == ObjectiveType.SPEED_AND_DIRECTION:
			if check_speed(true):
				print("Hello")
				label3d.text = wining_message
		elif objective_type == ObjectiveType.MAKE_ITEM:
			if check_items():
				label3d.text = wining_message
	pass

func check_speed(check_direction: bool = false) -> bool:
	var node = get_node(objective_node)
	for key in definition.keys():
		if key == "speed" and node is PowerNode:
			if abs(node.get("speed")) == abs(definition[key]):
				print("hola")
				if check_direction and sign(node.get("speed")) != sign(definition[key]):
					return false
				return true
	return false

func check_items() -> bool:
	var node = get_node(objective_node)
	for key in definition.keys():
		if key == "make" and node is Trash:
			if node.deleted_items > 0:
				label3d.text = "Congratulations!!"
				return true
	return false
