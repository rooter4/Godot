extends Node2D
const PLAT = preload("res://Scenes/expanding_platform.tscn")
var last_plat_x = 0
var current_plat = 0
var desired_plat = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	activate(10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func activate(number):
	$ExpandingPlatform.play_animation()
	desired_plat = number
func add_plat():
	current_plat+=1
	var new_plat = PLAT.instantiate()
	new_plat.global_position.x = last_plat_x + 16
	last_plat_x = new_plat.global_position.x
	add_child(new_plat)
	new_plat.play_animation()
	new_plat.animation_complete.connect(_on_expanding_platform_animation_complete)
func _on_expanding_platform_animation_complete():
	print("here")
	if(current_plat<desired_plat):
		add_plat()
