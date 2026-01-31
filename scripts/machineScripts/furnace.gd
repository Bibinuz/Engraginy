class_name Furnace extends Machine

@onready var gui : Control = $FurnaceGUI
#@onready var itemlist: ItemList = $FurnaceGUI/CenterContainer/ItemList

@export_storage var raw_material: Materials
@export_storage var fuel: Materials
@export_storage var processed_material: Materials

@export_storage var remaining_fuel: float
@export_storage var formula1 : Formula = Formula.new({"Iron ore": 2}, {"Iron ingot": 1}, 2)
@export_storage var aviable_formulas: Array[Formula] = [formula1]

@export_storage var active_formula: Formula = null

var gui_active: bool = false
var elapsed_time: float = 0.0

func _ready() -> void:
	await get_tree().physics_frame
	super()
	gui.hide()

func _process(delta: float) -> void:
	if not is_overstressed and abs(speed) > 0:
		meshes[0].rotate(Vector3(1, 0, 0), speed * delta)
	if is_placed:
		process_resources(delta)

func get_rotation_axis() -> Vector3:
		return global_transform.basis.x.normalized()

func process_resources(delta: float) -> void:
	if raw_material:
		for formula: Formula in aviable_formulas:
			if formula.input_materials.get(raw_material.resource_name):
				active_formula = formula

	try_input()
	if abs(speed) > 0 and not is_overstressed:
		process_formula(delta)
	try_output()

func interacted() -> void:
	print(connections)
	print(speed)
	pass
	#gui_active = true
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	#gui.show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit") and gui_active:
		gui_active = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		gui.hide()

func try_input() -> void:
	if input_ports[0].port_belt:
		var belt: Belt = input_ports[0].port_belt
		if belt.trying_to_pass and belt.trying_to_pass.material.is_flamable:
			if belt.try_remove_item(belt.trying_to_pass):
				if not fuel:
					fuel = belt.trying_to_pass.material.duplicate()
					fuel.amount = 1
					belt.trying_to_pass.queue_free()
				elif fuel.resource_name == belt.trying_to_pass.material.resource_name and fuel.amount <= fuel.max_stack:
					fuel.amount += 1
					belt.trying_to_pass.queue_free()
	if input_ports[1].port_belt:
		var belt: Belt = input_ports[1].port_belt
		if belt.trying_to_pass:
			if belt.try_remove_item(belt.trying_to_pass):
				if not raw_material:
					raw_material = belt.trying_to_pass.material.duplicate()
					raw_material.amount = 1
					belt.trying_to_pass.queue_free()
				elif raw_material.resource_name == belt.trying_to_pass.material.resource_name and raw_material.amount <= raw_material.max_stack:
					raw_material.amount += 1
					belt.trying_to_pass.queue_free()

func process_formula(delta: float) -> void:

	pass

func try_output() -> void:
	if processed_material and processed_material.amount > 0:
		if output_ports[1].try_pass_material(processed_material):
			processed_material.remove(1)
	if fuel and fuel.amount > 0:
		if remaining_fuel < 500:
			remaining_fuel+= fuel.energy
			fuel.remove(1)
		else:
			if output_ports[0].try_pass_material(fuel):
				fuel.remove(1)
