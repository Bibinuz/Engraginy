class_name Shaft extends PowerNode


@onready var shaftMesh = $shaftMesh

func _ready() -> void:

	super()


func _process(delta: float) -> void:
	super(delta)
	shaftMesh.rotate(Vector3(0,1,0), speed*delta)
	print(global_rotation)
	pass


func placed() -> void:
	super()
	if is_equal_approx(global_rotation.y, -PI):
		global_rotation.y = 0
	elif is_equal_approx(global_rotation.y, -PI/2):
		global_rotation.y = PI/2
	elif is_equal_approx(global_rotation.x, 0):
			global_rotation.y = -PI
