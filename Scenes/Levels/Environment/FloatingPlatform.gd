extends Node2D

var offset = Vector2(0,-150)
var duration = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()
	
func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	var tween2 = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween2.set_loops().set_parallel(false)
	tween.tween_property($Platform,"position", offset, duration/2.0)
	tween2.tween_property($Fan,"position", offset, duration/2.0)
	tween.tween_property($Platform,"position", Vector2.ZERO, duration/2.0)
	tween2.tween_property($Fan,"position", Vector2.ZERO, duration/2.0)

