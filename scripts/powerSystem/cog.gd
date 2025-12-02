class_name Gear extends PowerNode

@onready var cogMesh = $Gear

func _ready() -> void:
	super()
	cost_per_speed = -1
	pass

func _process(delta: float) -> void:
	super(delta)
	cogMesh.rotate(Vector3(0, 1, 0), speed * delta)

func placed() -> void:
	super()
	global_rotation = abs(global_rotation)
	if global_rotation.y > 3.1:
		global_rotation.y = 0
