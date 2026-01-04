class_name Belt extends PowerNode


class ItemPlacement extends Node3D:
	var visual_material: VisualMaterial
	var progress: float
	func _init() -> void:
		visual_material = null
		progress = -1


@export var belt_connections: Array[Node3D] = []
@export var shaderMaterial: ShaderMaterial

var allowed_connections: Array = [Shaft, MachinePort]
var belt_lenght: float = 0.0
var inventory: Array[ItemPlacement] = []

@onready var path: Path3D = $BeltPath

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
	meshes[0].set_instance_shader_parameter("speed", speed/2)
	if is_placed:
		manage_belt_items(delta)

func _input(event: InputEvent) -> void:
	if is_placed: return
	else:
		if event.is_action_pressed("leftClick"):
			place_belt()

func place_belt() -> void:
	if GlobalScript.focused_element is Shaft or GlobalScript.focused_element is MachinePort:
		if len(belt_connections) == 0:
			belt_connections.append(GlobalScript.focused_element)
		elif len(belt_connections) == 1 and not belt_connections.has(GlobalScript.focused_element):
			belt_connections.append(GlobalScript.focused_element)
			var place_position: Vector3 = belt_connections[0].global_position - belt_connections[1].global_position
			var center_position = place_position/2
			position = belt_connections[0].position - center_position
			GlobalScript.bottom_menu.place()
			belt_lenght = place_position.length() + 0.75
			scale.x = belt_lenght
			scale_path()
			if is_zero_approx(place_position.x) and is_zero_approx(place_position.y) and not is_zero_approx(place_position.z):
				rotation = Vector3(0,PI/2,0)
			elif not is_zero_approx(place_position.x) and is_zero_approx(place_position.y) and is_zero_approx(place_position.z):
				rotation = Vector3(0,0,0)
			else:
				print("Invalid: ", place_position)
				self.break_part()
				return

			for connection in belt_connections:
				if connection is MachinePort:
					connection.port_has_belt = self
			meshes[0].material_override = shaderMaterial

func scale_path() -> void:
	path.scale.x = 1/belt_lenght
	path.curve.set_point_position(0, Vector3(belt_lenght/2,0,0))
	path.curve.set_point_position(1, Vector3(-belt_lenght/2,0,0))

func check_placement() -> bool:
	if GlobalScript.focused_element and (GlobalScript.focused_element is Belt or GlobalScript.focused_element is MachinePort):
		placement_green()
		if len(belt_connections) == 2:
			return true
		else:
			return false
	placement_red()
	return false

func get_port_rotation_axis(_port: PowerNodePort) -> Vector3:
	return global_transform.basis.x.normalized()

func interacted() -> void:
	var visual_mat: VisualMaterial = load("res://scenes/iron_ore.tscn").instantiate()
	try_add_item(visual_mat, 0)
	see_inventory_state()
	print(belt_connections)

func break_part() -> void:
	for connection in belt_connections:
		if connection is MachinePort:
			connection.port_has_belt = null
	super()

func is_shaft_in_ends(shaft: Shaft) -> void:
	if shaft == belt_connections[0] or shaft == belt_connections[1]:
		break_part()

func manage_belt_items(delta: float) -> void:
	var to_erase: ItemPlacement = null
	for item: ItemPlacement in inventory:
		if item.visual_material:
			if len(item.visual_material.area.get_overlapping_areas()) == 0:
				item.progress += speed*delta/2
				item.visual_material.progress = item.progress

			#if is_equal_approx(item.visual_material.progress_ratio, 1):
			#	to_erase = item

	if to_erase:
		return
		#inventory.erase(to_erase)
		#to_erase.visual_material.queue_free()
		#to_erase.queue_free()

func see_inventory_state() -> void:
	print("Inventory state")
	for item: ItemPlacement in inventory:
		print(item.visual_material, " : ", item.progress)



func try_add_item(visual_mat: VisualMaterial, position_in_belt: float) -> bool:
	var is_there_an_item: bool = false
	for item in inventory:
		var n: float = 1
		if item.progress + n > position_in_belt and item.progress - n < position_in_belt:
			is_there_an_item = true
			break
	if not is_there_an_item:
		inventory.append(ItemPlacement.new())
		inventory[-1].visual_material = visual_mat
		inventory[-1].progress = 0
		path.add_child(inventory[-1].visual_material)
		return true
	return false


func try_remove_item(item: Material, position_in_belt: int) -> bool:
	return true
