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
		propagate_rotation(generator, generator.speed)

	for node: PowerNode in all_power_nodes:
		if all_power_nodes[node]:
			all_power_nodes[node] = false
		elif not all_power_nodes[node] and not node is Generator:
			node.speed = 0


func propagate_rotation(start_node: PowerNode, input_speed: int) -> void:
	var queue = []
	queue.append([start_node, input_speed])
	var visited_in_this_pass = []

	while queue.size() > 0:
		var data = queue.pop_front()
		var current : PowerNode= data[0]
		var prop_speed : int = data[1]

		if current in visited_in_this_pass:
			continue
		visited_in_this_pass.append(current)
		all_power_nodes[current] = true
		var connections : Dictionary[PowerNodePort, PowerNode] = current.get_connections()
		for actual_port : PowerNodePort in connections:
			if not connections[actual_port] is PowerNode:
				continue

			var connection:PowerNode = connections[actual_port]

			var my_axis : Vector3 =  current.get_rotation_axis()
			var connection_axis : Vector3 =  connections[actual_port].get_rotation_axis()
			var alignment : float =  my_axis.dot(connection_axis)
			var direction_flipper : int = int(signf(alignment))

			var  next_speed : int
			if  abs(alignment) > 0.9:
				var direct_transmision : bool = true
				if direct_transmision:
					if connection.speed != 0 and connection.speed != prop_speed*direction_flipper:
						break_priority(current, connection)
						continue

					next_speed = prop_speed*direction_flipper
			elif abs(alignment) < 0.1:
				#Todo
				print("Cog connected")
				next_speed = -prop_speed
			else:
				connection.break_part()
				continue
			if not connection is Generator:
				connection.speed = next_speed*actual_port.direction_fliper
			queue.append([connection, next_speed])

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
