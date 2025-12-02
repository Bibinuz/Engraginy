class_name Building extends Node3D

@onready var placementYesMaterial = preload("res://assets/materials/placement_yes.tres")
@onready var placementNoMaterial = preload("res://assets/materials/placement_no.tres")

@export_group("Meshes, areas and collistions of the building")
@export var meshes : Array[MeshInstance3D]
@export var areas : Array[Area3D]
@export var collisions : Array[StaticBody3D]


var is_placed : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not is_placed:
		toggle_collisions(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func check_placement() -> bool:
	for area in areas:
		if area.get_overlapping_areas() != []:
			placement_red()
			return false
	placement_green()
	return true

func placement_green() -> void:
	for mesh in meshes:
		mesh.material_override = placementYesMaterial
	pass

func placement_red() -> void:
	for mesh in meshes:
		mesh.material_override = placementNoMaterial
	pass

func placed() -> void:
	is_placed = true
	for mesh in meshes:
		mesh.material_override = null
		toggle_collisions(true)

func remove_building() -> void:
	self.queue_free()

func toggle_collisions(enabled: bool) -> void:
	for body:StaticBody3D in collisions:
		for child in body.get_children():
			if child is CollisionShape3D or child is CollisionPolygon3D:
				child.disabled = not enabled
