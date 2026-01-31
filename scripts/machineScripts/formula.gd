extends Node

class_name Formula

var input_materials : Dictionary[String, int]
var output_materials : Dictionary[String, int]
var time : float

func _init (input : Dictionary[String, int], output : Dictionary[String, int], t : float) -> void:
	input_materials = input
	output_materials = output
	time = t
