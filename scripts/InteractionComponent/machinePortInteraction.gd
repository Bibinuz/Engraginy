class_name MachinePortInteraction extends InteractionComponent


func _ready() -> void:
	parent = self.get_parent()
	connect_parent()

func _input(_event: InputEvent) -> void:
	pass

func in_range() -> void:
	focused = true
	GlobalScript.focused_element = parent
	MessageBus.interaction_focused.emit(context, new_icon, override_icon)
	set_process_input(true)

func not_in_range() -> void:
	focused = false
	if GlobalScript.focused_element == self:
		GlobalScript.focused_element = null
		set_process_input(false)

func on_interact() -> void:
	if parent.has_method("interacted"):
		parent.interacted()
	#print(parent.name)
