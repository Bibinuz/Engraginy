extends Node

var all_power_nodes: Dictionary[PowerNode, bool] = {}
var last_built_node : PowerNode = null
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

func register_node(node: PowerNode) -> void:
	if not all_power_nodes.has(node):
		all_power_nodes[node] = false
		last_built_node = node
		node.network_changed.connect(recalculate_all_grids)

func unregister_node(node: PowerNode) -> void:
	if all_power_nodes.has(node):
		all_power_nodes.erase(node)
		if node.is_connected("network_changed", recalculate_all_grids):
			node.network_changed.disconnect(recalculate_all_grids)

func recalculate_all_grids() -> void:
	var generator_nodes : Array[Generator] = []
	for node : PowerNode in all_power_nodes:
		if node is Generator and node.is_running:
			generator_nodes.append(node)
	for generator : Generator in generator_nodes:
		pass
		#propagate_rotation(generator, generator.speed)

	for node: PowerNode in all_power_nodes:
		if all_power_nodes[node]:
			all_power_nodes[node] = false
		elif not all_power_nodes[node] and not node is Generator:
			node.speed = 0.0


func propagate_rotation(start_node: PowerNode, input_speed: int) -> void:
	var queue = []
	queue.append([start_node, input_speed])
	var visited : Dictionary[PowerNode, int] = {}

	while queue.size() > 0:
		var data = queue.pop_front()
		var current : PowerNode= data[0]
		var prop_rpm : int = data[1]

		if current in visited:
			continue
		visited[current] = prop_rpm
		all_power_nodes[current] = true

		for local_port : PowerNodePort in current.connections:
			if not current.connections.has(local_port):
				continue
			var connection_data : PortConnection = current.connections[local_port]
			var connected_node : PowerNode = connection_data.get("node")
			var connected_port : PowerNodePort = connection_data.get("port")
			var  next_rpm : int = 0

			if local_port.type == PowerNodePort.PortType.SHAFT_END and connected_port.type == PowerNodePort.PortType.SHAFT_END:
				var alignment = current.get_rotation_axis().dot(connected_node.get_rotation_axis())
				if abs(alignment) > 0.9:
					next_rpm = prop_rpm * sign(alignment)
				else:
					break_priority(current, connected_node)
					continue
			elif local_port.type  == PowerNodePort.PortType.COG_SMALL and connected_port.type == PowerNodePort.PortType.COG_SMALL:
				next_rpm = -prop_rpm
			elif local_port.type  == PowerNodePort.PortType.COG_SMALL and connected_port.type == PowerNodePort.PortType.COG_BIG:
				next_rpm  = int(-prop_rpm / 2.0)
			elif local_port.type  == PowerNodePort.PortType.COG_BIG and connected_port.type == PowerNodePort.PortType.COG_SMALL:
				next_rpm  = int(-prop_rpm * 2.0)
			elif local_port.type  == PowerNodePort.PortType.COG_BIG and connected_port.type == PowerNodePort.PortType.COG_BIG:
				next_rpm  = -prop_rpm
			else:
				continue

			current.speed = next_rpm
			queue.append([connected_node, next_rpm])

func break_priority(node1 : PowerNode, node2 : PowerNode) -> void:
	# First case:
		# The two nodes are generators: break the last built one, or the node1 by default
	if node1 is Generator and node2 is Generator:
		if node1 == last_built_node:
			node1.break_part()
		elif node2 == last_built_node:
			node2.break_part()
		else:
			node1.break_part()
	# Second case:
		# Node 1 is a generator, then we break the link, node 2
	elif node1 is Generator:
		node2.break_part()
	# Same thing but reversed
	elif node2 is Generator:
		node1.break_part()
	# Last case:
		# Neither of them are generators, we break last built one, or node1 by default
	else:
		if node1 == last_built_node:
			node1.break_part()
		elif node2 == last_built_node:
			node2.break_part()
		else:
			node1.break_part()
	return


##func find_whole_grid_bfs(start_node: PowerNode) -> Array[PowerNode]:
##	var visited: Array[PowerNode] = []
##	var queue: Array[PowerNode] = [start_node]
##	visited.append(start_node)
##	while not queue.is_empty():
	##		var current_node = queue.pop_front()
	##		for connection in current_node.get_connections():
		##			if connection not in visited:
			##				visited.append(connection)
			##				queue.append(connection)
			##	return visited
			##
			##func find_whole_grid_dfs(start_node: PowerNode) -> Array[PowerNode]:
				##	var visited: Array[PowerNode] = []
				##	var queue: Array[PowerNode] = [start_node]
				##	visited.append(start_node)
				##	while not queue.is_empty():
					##		var current_node = queue.pop_back()
					##		for connection in current_node.get_connections():
						##			if connection not in visited:
							##				visited.append(connection)
							##				queue.append(connection)
							##	return visited
