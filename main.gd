extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fuz_mob_death(position):
	const BLOSS = preload("res://Scenes/Effects/death_blossom.tscn")
	var new_bloss = BLOSS.instantiate()
	new_bloss.global_position = position
	add_child(new_bloss)
	new_bloss.emitting = true
