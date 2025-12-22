class_name Miner extends Machine


@export var drill_collision: CollisionShape3D


func _process(delta: float) -> void:
	super(delta)
	meshes[1].rotate(Vector3(0,1,0), delta*speed)

func check_placement() -> bool:
	placement_green()
	return true
