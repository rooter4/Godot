extends Area2D

@onready var anim_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = anim_position


func _on_animation_player_animation_finished(anim_name):
	queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
		$LeftPound.disabled = true
		$RightPound.disabled = true