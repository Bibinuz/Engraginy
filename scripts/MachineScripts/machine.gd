class_name Machine extends PowerNode

enum Strategy {
	FORWARD,
	GENERATE,
	CONVERT
}

@export_group("Machine data")
@export var input_ports_path : Array[NodePath]
@export var output_ports_path : Array[NodePath]
#@export var aviable_formulas : Array[Formula]

var input_ports: Array[MachinePort] = []
var output_ports: Array[MachinePort] = []

#var selected_formula : int

@export_group("Machine characteristics")
#@export var strategy : Strategy
@export var production_speed : float = 1.0

func _ready() -> void:
	super()
	cost_per_speed = -1

func _process(_delta: float) -> void:
	pass

func _enter_tree() -> void:
	super()

func load_node_exports() -> void:
	super()
	load_singular_node_path(input_ports_path, input_ports, MachinePort)
	load_singular_node_path(output_ports_path, output_ports, MachinePort)

func set_power_state() -> void:
	if is_overstressed:
		production_speed = 0
	else:
		print("System overstressed")

	if speed == 0:
		print("Machine is Off")
	else:
		print("Machine is On and connected at: ", speed)

func break_part() -> void:
	for port: MachinePort in input_ports:
		if port and port.port_belt:
			port.port_belt.break_part()
	for port: MachinePort in output_ports:
		if port and port.port_belt:
			port.port_belt.break_part()
	super()
