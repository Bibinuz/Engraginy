class_name Level extends Node3D


func _ready() -> void:
	GlobalScript.world = self
	GlobalScript.build_list = $Buildings
