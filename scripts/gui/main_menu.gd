extends Control


@onready var main_screen: Control = $MainScreen
@onready var tutorial_screen: Control = $TutorialMenu

var EMPTY_GAME_SCENE = "res://scenes/world.scn"

func _ready() -> void:
	tutorial_screen.visible = false
	main_screen.visible = true

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file(EMPTY_GAME_SCENE)

func _on_load_game_pressed() -> void:
	get_tree().change_scene_to_file(EMPTY_GAME_SCENE)
	#print(get_tree().is_class("Level"))
	var load_event: InputEventAction = InputEventAction.new()
	load_event.action = "Load"
	load_event.pressed = true

	GlobalScript._input(load_event)

func _on_tutorials_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	var quit_event: InputEventAction = InputEventAction.new()
	quit_event.action = "closeProject"
	quit_event.pressed = true
	GlobalScript._input(quit_event)
	pass # Replace with function body.
