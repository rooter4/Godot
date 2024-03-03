extends Node

var path = ""
var start = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	print("im ready")
	const LEVEL = preload("res://Scenes/Levels/Level00/level_00.tscn")
	var level = LEVEL.instantiate()
	start = level.get_start()
	add_child(level)
	
func save():
	var save_dict ={
		"object": get_path(),
	}
	return save_dict
func load(data):
	print(str(data))
func get_start():
	return start
func save_new():
	var save_dict ={
		"object": get_path(),
	}
	return save_dict
