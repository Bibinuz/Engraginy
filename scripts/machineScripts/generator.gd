class_name Generator extends PowerNode

@onready var motorShaft : MeshInstance3D = $Shaft
@export var generate_per_speed : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	speed = 0.0
	is_passive=false
	is_running = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	motorShaft.rotate(Vector3(0, 1, 0), speed * delta)
	#if not is_overstressed and is_running:



func placed() -> void:
	super()
	speed = 1.0
