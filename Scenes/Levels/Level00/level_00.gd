extends Node
func _on_bounds_body_entered(body):
	print(body.name)
	if(body.name == "Player"):
		get_tree().reload_current_scene()
func get_start():
	return $SpawnPoint.global_position
