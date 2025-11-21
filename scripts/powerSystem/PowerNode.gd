class_name PowerNode extends Building

signal network_changed

var connections : Array[PowerNode] = []
var speed : float = 0.0
var direction : int = 0
var cost_per_speed : float = 0.0
var is_overstressed : bool = false

func _ready() -> void:
	for port in $ConnectionPorts.get_children():
		if port is Area3D:
			port.monitorable = false
			port.monitoring = false


func _process(_delta: float) -> void:
	pass

func _enter_tree() -> void:
	PowerGridManager.register_node(self)

func _exit_tree() -> void:
	PowerGridManager.unregister_node(self)

func _on_area_entered(area: Area3D) -> void:
	var other_node = area.get_owner()
	if other_node is PowerNode and other_node != self:
		if not connections.has(other_node):
			connections.append(other_node)
		if not other_node.connections.has(self):
			other_node.connections.append(self)
		emit_signal("network_changed")

func _on_area_exited(area: Area3D) -> void:
	var other_node = area.get_owner()
	if other_node is PowerNode:
		if connections.has(other_node):
			connections.erase(other_node)
		if other_node.connections.has(self):
			other_node.connections.erase(self)
		emit_signal("network_changed")

func get_connections() ->  Array[PowerNode]:
	return connections

func placed() -> void:
	super()

	for port in $ConnectionPorts.get_children():
		if port is Area3D:
			port.area_entered.connect(_on_area_entered)
			port.area_exited.connect(_on_area_exited)
			port.monitoring = true
			port.monitorable = true

func check_connections() -> bool:

	return true
