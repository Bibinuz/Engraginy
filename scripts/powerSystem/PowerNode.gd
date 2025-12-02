class_name PowerNode extends Building

enum PortType{
	SHAFT_END,
	COG_SMALL,
	COG_BIG
}

signal network_changed

@export var cost_per_speed : int = 0
@export var is_passive:bool=true

# Connections[local_port] = [other_node, other_port]
# Dictionary[PowerNodePort, Array[PowerNode, PowerNodePort]]
var connections : Dictionary[PowerNodePort, PortConnection] = {}
var speed : float = 0.0
var is_overstressed : bool = false
var is_running : bool = false
var is_broken : bool = false

func _ready() -> void:
	for port in $ConnectionPorts.get_children():
		if port is Area3D:
			port.monitorable = false
			port.monitoring = false
			port.area_entered.connect(_on_area_entered.bind(port))
			port.area_exited.connect(_on_area_exited.bind(port))


func _process(delta: float) -> void:
	super(delta)
	if is_passive:
		check_speeds()
	pass

func _enter_tree() -> void:
	PowerGridManager.register_node(self)

func _exit_tree() -> void:
	PowerGridManager.unregister_node(self)

func _on_area_entered(other_port: Area3D, local_port: PowerNodePort) -> void:
	if not other_port is PowerNodePort:
		return
	var other_node = other_port.get_power_node()
	if local_port.can_connect_to(other_port):
		connections[local_port] = PortConnection.new(other_node, other_port)
		other_node.connections[other_port] = PortConnection.new(self,  local_port)
		emit_signal("network_changed")

func _on_area_exited(area: Area3D, local_port: PowerNodePort) -> void:
	var other_node = area.get_owner()
	if other_node is PowerNode:
		connections[local_port] = null
		other_node.connections[area] = null
		emit_signal("network_changed")

func get_connections() -> Dictionary[PowerNodePort, PowerNode]:
	return {}

func placed() -> void:
	super()
	for port in $ConnectionPorts.get_children():
		if port is Area3D:
			port.monitoring = true
			port.monitorable = true

func get_rotation_axis() -> Vector3:
	return global_transform.basis.y.snappedf(1)

func break_part() -> void:
	if is_broken: return
	is_broken = true
	print(name + " Has exploded due to direction conflicts")
	remove_building()

func check_speeds() -> void:
	var suposed_speed:float = 0.0
	for port: PowerNodePort in connections:
		var temp_speed: float = 0.0
		if  connections[port] != null:
			var connection:PortConnection = connections[port]
			var input_speed: float = connection.node.speed * connection.port.ratio_multipier * connection.port.direction_fliper
			temp_speed  = (input_speed*port.direction_fliper)/port.ratio_multipier
			if port.type == PortType.COG_SMALL or port.type == PortType.COG_BIG:
				## temp_speed = -temp_speed
				pass

		if  not is_equal_approx(temp_speed, suposed_speed) and not is_zero_approx(suposed_speed) and (not is_zero_approx(temp_speed)):
			break_part()
			return
		if is_zero_approx(suposed_speed) and not is_zero_approx(temp_speed):
			suposed_speed = temp_speed
	self.speed=suposed_speed
