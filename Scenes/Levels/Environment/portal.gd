extends StaticBody2D
var one_shot = true
func interact(body):
	if one_shot:
		$AnimatedSprite2D.play("open")
		body.change_energy(-2)
		body.global_position = global_position
		body.global_position.x+=8
		body.global_position.y -= 20
		one_shot = false
		set_meta("interact",null)
		return 2.0
	else:
		return 0.0
	
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.get_animation() == "open":
		$AnimatedSprite2D.play("green")
