class_name PowerNodePort extends Area3D

enum PortType{
	SHAFT_END,
	COG_SMALL,
	COG_BIG
}

@export var ratio_multipier : float = 1.0
@export var direction_fliper : int = 1
@export var type : PortType = PortType.SHAFT_END
@export var allow_ports: Array[PortType]

func  can_connect_to(other_port: PowerNodePort) -> bool:
	if allow_ports.has(other_port.type) and self.get_power_node() != other_port.get_power_node():
		return true
	return false

func get_power_node() -> PowerNode:
	return get_owner() as PowerNode
