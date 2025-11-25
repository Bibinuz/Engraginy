extends Node

var debug
var player: PlayerCharacter
var ui_context: ContextComponent


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("closeProject"):
		get_tree().quit()
