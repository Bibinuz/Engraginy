class_name Level extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Ready level")
	GlobalScript.world = self
	GlobalScript.build_list = $Buildings
	print("Buildings node: ",$Buildings)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
