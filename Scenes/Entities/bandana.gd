extends Area2D

func _on_body_entered(body):
	if(body.name == "Player"):
		if body.has_method("add_ability"):
			body.add_ability("ability_slash")
			$AnimatedSprite2D.play("collect")

func _on_animated_sprite_2d_animation_finished():
	if($AnimatedSprite2D.get_animation() == "collect"):
		queue_free()
