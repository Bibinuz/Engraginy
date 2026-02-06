extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("PauseMenu ready")
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		if is_visible_in_tree():
			exit()
		else:
			enter()

func exit() -> void:
	GlobalScript.opened_gui = null
	GlobalScript.bottom_menu.show()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	get_tree().paused = false

func enter() -> void:
	if GlobalScript.opened_gui:
		GlobalScript.opened_gui.hide()

	GlobalScript.opened_gui = self
	GlobalScript.bottom_menu.hide()
	mouse_filter = Control.MOUSE_FILTER_PASS
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
	get_tree().paused = true


func _on_resume_pressed() -> void:
	exit()

func _on_save_game_pressed() -> void:
	GlobalScript.save_game()
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(GlobalScript.MAIN_MENU)
	pass # Replace with function body.
