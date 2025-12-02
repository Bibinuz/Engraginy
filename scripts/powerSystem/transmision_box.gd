extends PowerNode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	meshes[0].rotate(Vector3(0,1,0), speed*delta)
	meshes[1].rotate(Vector3(0,1,0), -speed*delta)
	meshes[2].rotate(Vector3(1,0,0), speed*delta)
	meshes[3].rotate(Vector3(1,0,0), -speed*delta)
