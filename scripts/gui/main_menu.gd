extends Control


@onready var main_screen: Control = $MainScreen
@onready var tutorial_screen: Control = $TutorialMenu


func _ready() -> void:
	tutorial_screen.visible = false
	main_screen.visible = true

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file(GlobalScript.EMPTY_GAME_SCENE)

	var load_event: InputEventAction = InputEventAction.new()
	load_event.action = "Load"
	load_event.pressed = true
	GlobalScript._input(load_event)

func _on_load_game_pressed() -> void:
	get_tree().change_scene_to_file(GlobalScript.EMPTY_GAME_SCENE)
	GlobalScript.to_load = GlobalScript.folder_save_path + GlobalScript.file_save_path
	GlobalScript.pending_load_action = true
	#var load_event: InputEventAction = InputEventAction.new()
	#load_event.action = "Load"
	#load_event.pressed = true
	#lobalScript._input(load_event)

func _on_tutorials_pressed() -> void:
	main_screen.hide()
	tutorial_screen.show()

func _on_exit_pressed() -> void:
	var quit_event: InputEventAction = InputEventAction.new()
	quit_event.action = "closeProject"
	quit_event.pressed = true
	GlobalScript._input(quit_event)
