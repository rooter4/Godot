extends Node

var level = 0
var path = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	
	const LEVEL = preload("res://Scenes/Levels/Level00/level_00.tscn")
	var level = LEVEL.instantiate()
	add_child(level)
	
func save():
	var save_dict ={
		"object": get_path(),
		"current_level" : level
	}
	return save_dict
func load(data):
	print(str(data))
