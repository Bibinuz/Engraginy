class_name Shaft extends PowerNode


@onready var shaftMesh = $shaftMesh

func _ready() -> void:
	super()


func _process(delta: float) -> void:
	shaftMesh.rotate(Vector3(0,1,0), speed*delta)
	pass
