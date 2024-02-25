extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var start = $LevelManager.get_child(0).get_child(0).global_position
	$player.global_position = start


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_fuz_mob_death(position):
	const BLOSS = preload("res://Scenes/Effects/death_blossom.tscn")
	var new_bloss = BLOSS.instantiate()
	new_bloss.global_position = position
	add_child(new_bloss)
	new_bloss.emitting = true
func on_player_pause():
	$player.pause = true
