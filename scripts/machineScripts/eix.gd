class_name Shaft extends Node3D

var connection1 : Node3D
var connection2 : Node3D

var speed : float = 0.0
var stress : float = 0.0

@onready var ray1 : RayCast3D = $Ray1
@onready var ray2 : RayCast3D = $Ray2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(Vector3(0, 0, 1), speed*delta)
	pass
	
func _physics_process(delta: float) -> void:
	connection1 = ray1.get_collider()
	connection2 = ray2.get_collider()
	
	if connection1 and connection1.get_parent() :#and connection1.get_parent().is_class("Generator"):
		print(connection1.get_parent().get_class())
		pass
	
	if connection2 != null :
		pass
