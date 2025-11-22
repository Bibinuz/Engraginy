class_name PowerNode extends Building


signal network_changed

@export var cost_per_speed : int = 0

var connections : Dictionary[Area3D, PowerNode] = {}
var speed : int = 0
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


func _process(_delta: float) -> void:
	pass

func _enter_tree() -> void:
	PowerGridManager.register_node(self)


func _exit_tree() -> void:
	PowerGridManager.unregister_node(self)

func _on_area_entered(area: Area3D, local_port: Area3D) -> void:
	var other_node = area.get_owner()
	if other_node is PowerNode and other_node != self:
		connections[local_port] = other_node
		other_node.connections[area] = self
		emit_signal("network_changed")


func _on_area_exited(area: Area3D, local_port: Area3D) -> void:
	var other_node = area.get_owner()
	if other_node is PowerNode:
		connections[local_port] = null
		other_node.connections[area] = null
		emit_signal("network_changed")

func get_connections() -> Array[PowerNode]:
	return connections.values()

func placed() -> void:
	super()
	for port in $ConnectionPorts.get_children():
		if port is Area3D:
			port.monitoring = true
			port.monitorable = true

func check_connections() -> bool:
	return true

func get_rotation_axis() -> Vector3:
	return global_transform.basis.y.snappedf(1)

func break_part() -> void:
	if is_broken: return
	is_broken = true
	print(name + " Has exploded due to direction conflicts")
	remove_building()
