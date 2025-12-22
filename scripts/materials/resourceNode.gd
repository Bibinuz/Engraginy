class_name ResourceNode extends Node3D

enum Purity{
	IMPURE,
	NORMAL,
	PURE
}


@export var resource_type: Materials
@export var purity: Purity
