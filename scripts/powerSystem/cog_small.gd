class_name Gear extends PowerNode

@onready var cogMesh = $Gear

func _ready() -> void:
	super()
	cost_per_speed = -1
	pass

func _process(delta: float) -> void:
	if not valid_connections():
		self._exit_tree()
		remove_building()
	if not is_overstressed:
		cogMesh.rotate(Vector3(0, 1, 0), speed * delta)
	pass

func valid_connections() -> bool:
	return true

func placed() -> void:
	super()
	global_rotation = abs(global_rotation)
	if global_rotation.y > 3.1:
		global_rotation.y = 0
