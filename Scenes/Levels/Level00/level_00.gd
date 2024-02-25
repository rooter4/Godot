extends Node
func _on_bounds_body_entered(body):
	if(body.name == "player"):
		get_tree().reload_current_scene()
