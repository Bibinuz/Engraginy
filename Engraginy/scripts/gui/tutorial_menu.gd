extends Panel



var TUTORIAL_EASY_MAP: String = "res://scenes/tutorial-easy.scn"
var TUTORIAL_MEDIUM_MAP: String = "res://scenes/tutorial-medium.scn"
var TUTORIAL_HARD_MAP: String = "res://scenes/tutorial-hard.scn"

func _on_back_pressed() -> void:
	get_parent().main_screen.show()
	self.hide()

func _on_iniciate_pressed() -> void:
	get_tree().change_scene_to_file(TUTORIAL_EASY_MAP)

func _on_intermediary_pressed() -> void:
	get_tree().change_scene_to_file(TUTORIAL_MEDIUM_MAP)

func _on_advanced_pressed() -> void:
	get_tree().change_scene_to_file(TUTORIAL_HARD_MAP)
