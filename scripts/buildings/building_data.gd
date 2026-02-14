extends Resource

enum BuildingCategory {
	MACHINE,
	GENERATOR,
	POWER_NODE,
	FUNDATIONS,
	DECORATION
}

@export var display_name: String
@export var category: BuildingCategory
@export var icon: CompressedTexture2D
@export var scene: PackedScene
@export var cost: Array
