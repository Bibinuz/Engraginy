class_name Shaft extends PowerNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	cost_per_speed = -1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previousd frame.
func _process(delta: float) -> void:
	if not valid_connections():
		remove_building()
	if not is_overstressed:
		if (abs(basis.get_euler().y) >= PI/2-0.01 and abs(basis.get_euler().y) <= PI/2+0.01):
			rotate(Vector3(1, 0, 0), direction * speed * delta)
		else:
			rotate(Vector3(0, 0, 1), direction * speed * delta)
			
	pass
	
func _physics_process(_delta: float) -> void:
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
