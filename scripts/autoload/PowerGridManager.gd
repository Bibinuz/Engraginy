extends Node

var all_power_nodes: Array[PowerNode] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func register_node(node: PowerNode) -> void:
	if not all_power_nodes.has(node):
		all_power_nodes.append(node)
		node.network_changed.connect(recalculate_all_grids)

func wunregister_node(node: PowerNode) -> void:
	if all_power_nodes.has(node):
		all_power_nodes.erase(node)
		if node.is_connected("network_changed", recalculate_all_grids):
			node.network_changed.disconnect(recalculate_all_grids)
	
func recalculate_all_grids() -> void:
	# Es recalculen totes les xarxes abans d'actualitzar les velocitats del sistema
	# Els canvis de consum no es propaguen fins al seguent canvi
	print("Start recalculating all grids: ")
	var processed_nodes: Array[PowerNode] = []
	
	for node in all_power_nodes:
		if node in processed_nodes:
			continue
		var grid_nodes = find_whole_grid_bfs(node)
		processed_nodes.append_array(grid_nodes)
		
		var production_aviable: float = 0.0
		for grid_node in grid_nodes:
			production_aviable += grid_node.speed * grid_node.cost_per_speed
		print(production_aviable)
		
		var is_overstressed: bool = production_aviable < 0
		for grid_node in grid_nodes:
			grid_node.is_overstressed = is_overstressed
	print("End recalculation of all grids")
	

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
