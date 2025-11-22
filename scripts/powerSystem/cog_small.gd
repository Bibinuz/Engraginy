class_name Gear extends PowerNode

@onready var cogMesh = $Gear
@onready var gearConnections = $GearConnections

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	cost_per_speed = -1
	for port in gearConnections.get_children():
		if port is Area3D:
			port.monitorable = false
			port.monitoring = false
	pass # Replace with function body.

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
	for port in gearConnections.get_children():
		if port is Area3D:
			port.monitorable = true
			port.monitoring = true
	global_rotation = abs(global_rotation)
	if global_rotation.y > 3.1:
		global_rotation.y = 0
