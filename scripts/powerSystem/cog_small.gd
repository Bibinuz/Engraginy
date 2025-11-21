extends PowerNode

@onready var cogMesh = $Gear

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	cost_per_speed = -1
	pass # Replace with function body.

func _process(delta: float) -> void:
	if not valid_connections():
		self._exit_tree()
		remove_building()
	if not is_overstressed:
		cogMesh.rotate(Vector3(0, 1, 0), direction * speed * delta)
	pass

func valid_connections() -> bool:
	if len(connections) == 2:
		if connections[0].direction != connections[1].direction and connections[0].direction != 0 and connections[1].direction != 0:
			return false
		elif connections[0].speed > connections[1].speed:
			speed = connections[0].speed
			direction = connections[0].direction
		else:
			speed = connections[1].speed
			direction = connections[1].direction
	elif len(connections) == 1:
		if connections[0]:
			speed = connections[0].speed
			direction = connections[0].direction
	else:
		speed = 0
	return true

func placed() -> void:
	super()
	global_rotation = abs(global_rotation)
	if global_rotation.y > 3.1:
		global_rotation.y = 0
