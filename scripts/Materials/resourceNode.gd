class_name ResourceNode extends Node3D

enum Purity{
	IMPURE,
	NORMAL,
	RICH,
	PURE
}


@export var resource_type: Materials
@export var purity: Purity

func _ready() -> void:
	print("Resource node: ", resource_type.name, " ready")
