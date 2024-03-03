extends Node

var main_menu = preload("res://Scenes/Game Tree/MainMenu.tscn").instantiate()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	$AnimationPlayer.play("button_out")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "button_out":
		navigate_to_menu()
func navigate_to_menu():
	queue_free()
	get_tree().root.add_child(main_menu)
