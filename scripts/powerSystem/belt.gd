class_name Belt extends PowerNode


@export var belt_connections: Array = []
@export var shaderMaterial: ShaderMaterial

var allowed_connections: Array = [Shaft, MachinePort]

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	super(_delta)
	meshes[0].set_instance_shader_parameter("speed", speed)

func _input(event: InputEvent) -> void:
	if is_placed: return
	else:
		if event.is_action_pressed("leftClick"):
			if GlobalScript.focused_element is Shaft or GlobalScript.focused_element is MachinePort:
				if len(belt_connections) == 0:
					belt_connections.append(GlobalScript.focused_element)
				elif len(belt_connections) == 1 and not belt_connections.has(GlobalScript.focused_element):
					belt_connections.append(GlobalScript.focused_element)
					var place_position: Vector3 = belt_connections[0].position - belt_connections[1].position
					var center_position = place_position/2
					if place_position.x == 0 and place_position.y == 0 and place_position.z != 0:
						GlobalScript.bottom_menu.place()
						position = belt_connections[0].position - center_position
						rotation = Vector3(0,PI/2,0)
						scale.x = place_position.length() + 0.75
					elif place_position.x != 0 and place_position.y == 0 and place_position.z == 0:
						GlobalScript.bottom_menu.place()
						position = belt_connections[0].position - center_position
						rotation = Vector3(0,0,0)
						scale.x = place_position.length() + 0.75
					else:
						self.break_part()
						return
					meshes[0].material_override = shaderMaterial




func check_placement() -> bool:
	var n: int = len(belt_connections)
	if n != 2:
		placement_red()
		return false
	placement_green()
	return true

func get_port_rotation_axis(_port: PowerNodePort) -> Vector3:
	return global_transform.basis.x.normalized()

func interacted() -> void:
	print(name, ": ", global_transform.basis.x.normalized())
