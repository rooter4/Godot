extends StaticBody2D

func interact(body):
	$AnimatedSprite2D.play("start")
	$AnimatedSprite2D.flip_h = body.sprite_2d.flip_h
	body.change_energy(body.max_energy)
	body.global_position = global_position
	body.global_position.x+=8
	return 1.5

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.get_animation() == "start":
		set_meta("interact",null)
		$AnimatedSprite2D.play("end")
