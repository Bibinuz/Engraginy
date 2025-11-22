extends Node

var all_power_nodes: Array[PowerNode] = []

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	#recalculate_all_grids()
	pass



func register_node(node: PowerNode) -> void:
	if not all_power_nodes.has(node):
		all_power_nodes.append(node)
		node.network_changed.connect(recalculate_all_grids)

func unregister_node(node: PowerNode) -> void:
	if all_power_nodes.has(node):
		all_power_nodes.erase(node)
		if node.is_connected("network_changed", recalculate_all_grids):
			node.network_changed.disconnect(recalculate_all_grids)

func recalculate_all_grids() -> void:

	# Es recalculen totes les xarxes abans d'actualitzar les velocitats del sistema
	# Els canvis de consum no es propaguen fins al seguent canvi
	var generator_nodes : Array[Generator] = []
	for node : PowerNode in all_power_nodes:
		if not node is Generator:
			node.speed = 0
			node.is_broken = false
		else:
			if  node.is_running:
				generator_nodes.append(node)
	##print("We have  ",  len(generator_nodes), " generators")
	##print(generator_nodes)
	for generator : Generator in generator_nodes:
		propagate_rotation(generator, generator.speed)



func propagate_rotation(start_node: PowerNode, input_speed: int):
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
		if current.speed != 0:
			print(current.speed, " : ", prop_speed)
			if current.speed != prop_speed:
				current.break_part()
				return
			current.speed = prop_speed
		for connection : PowerNode in current.get_connections():
			if not connection:
				continue

			var my_axis : Vector3 =  current.get_rotation_axis()
			var connection_axis : Vector3 =  connection.get_rotation_axis()
			var alignment : float =  my_axis.dot(connection_axis)

			var  next_speed
			if  abs(alignment) > 0.9:
				var direction_flipper : float = signf(alignment)
				next_speed = prop_speed*direction_flipper
			elif abs(alignment) < 0.1:
				#Falta per fer
				next_speed = prop_speed
			else:
				connection.break_part()
				continue
			connection.speed = next_speed
			queue.append([connection, next_speed])


#Afegeixo les dues versions bfs i dfs per despres fer probes de rendiment
#No espero gaire canvi
func find_whole_grid_bfs(start_node: PowerNode) -> Array[PowerNode]:
	var visited: Array[PowerNode] = []
	var queue: Array[PowerNode] = [start_node]
	visited.append(start_node)
	while not queue.is_empty():
		var current_node = queue.pop_front()
		for connection in current_node.get_connections():
			if connection not in visited:
				visited.append(connection)
				queue.append(connection)
	return visited

func find_whole_grid_dfs(start_node: PowerNode) -> Array[PowerNode]:
	var visited: Array[PowerNode] = []
	var queue: Array[PowerNode] = [start_node]
	visited.append(start_node)
	while not queue.is_empty():
		var current_node = queue.pop_back()
		for connection in current_node.get_connections():
			if connection not in visited:
				visited.append(connection)
				queue.append(connection)
	return visited
