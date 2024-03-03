extends Node
var game = preload("res://Scenes/Game Tree/Game.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_pressed():
	get_tree().quit()


func _on_start_game_pressed():
	queue_free()
	get_tree().root.add_child(game)
