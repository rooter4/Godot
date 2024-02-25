extends Area2D

@onready var anim_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = anim_position


func _on_animation_player_animation_finished():
	queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1, body)
		$LeftPound.set_deferred("disabled",true)
		$RightPound.set_deferred("disabled" ,true)
