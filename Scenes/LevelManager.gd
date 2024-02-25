extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	const LEVEL = preload("res://Scenes/Levels/Level00/level_00.tscn")
	var level = LEVEL.instantiate()
	add_child(level)
	


