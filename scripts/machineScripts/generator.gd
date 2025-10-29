class_name Generator extends Node3D

@export var speed : float = 0.0
@export var stressPerSpeed : float = 8
@onready var motorShaft = $Shaft

var stress : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	stress = abs(speed)*stressPerSpeed
	motorShaft.rotate(Vector3(0,0,1), speed * delta)

		
