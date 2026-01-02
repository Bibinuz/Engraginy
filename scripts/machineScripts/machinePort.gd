class_name MachinePort extends StaticBody3D

var machine: Machine

var port_has_belt: Belt = null

func _process(_delta: float) -> void:
	pass

func interacted()-> void:
	print(global_rotation)
