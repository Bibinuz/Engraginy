extends Panel



var TUTORIAL_EASY_MAP: String = "res://scenes/tutorial-easy.scn"


func _on_back_pressed() -> void:
	get_parent().main_screen.show()
	self.hide()

func _on_iniciate_pressed() -> void:
	get_tree().change_scene_to_file(TUTORIAL_EASY_MAP)
	#GlobalScript.building_menu.hide_tabs(["Production","Fundations", "Decorations"])
	#GlobalScript.load_tutorial(1)
	pass

func _on_intermediary_pressed() -> void:
	get_tree().change_scene_to_file(GlobalScript.EMPTY_GAME_SCENE)
	GlobalScript.load_tutorial(2)
	pass

func _on_advanced_pressed() -> void:
	get_tree().change_scene_to_file(GlobalScript.EMPTY_GAME_SCENE)
	GlobalScript.load_tutorial(3)
	pass
