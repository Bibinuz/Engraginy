class_name Trash extends Machine

signal trash_deleted

func _ready() -> void:
	super()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_placed:
		accept_input()
	pass


func accept_input() -> void:
	if input_ports[0].port_belt:
		var temp: Belt = input_ports[0].port_belt
		if temp.trying_to_pass:
			if temp.try_remove_item(temp.trying_to_pass):
				emit_signal("trash_deleted", temp.trying_to_pass.material.name)
				temp.trying_to_pass.queue_free()
