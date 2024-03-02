extends StaticBody2D

signal extend_bridge
func interact(body):

	$AnimatedSprite2D.play("open")
	body.change_energy(-2)
	body.global_position = global_position
	body.global_position.x+=8
	body.global_position.y -= 20
	set_meta("interact",null)
	return 1.0

	
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.get_animation() == "open":
		$AnimatedSprite2D.play("green")
		extend_bridge.emit()
