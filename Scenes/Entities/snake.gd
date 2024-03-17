extends StaticBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.

var can_jump = true
var can_attack = true
var health = 2
func _process(delta):
	# Add the gravity.
	if $Front.is_colliding():
		if($Front.get_collider().name =="Player"):
			attack()
	if $Rear.is_colliding():
		if($Rear.get_collider().name =="Player"):
			flip()


func _on_animated_sprite_2d_animation_finished():
	var name =$AnimatedSprite2D.get_animation()
	if  name == "attack" or name == "jump":
		$AnimatedSprite2D.play("default")
		$Area2D.get_child(0).disabled = true
func flip():
	scale.x= -1
func attack():
	if can_attack:
		$AnimatedSprite2D.play("attack")
		$Area2D.get_child(0).disabled = false
		can_attack = false
		$AttackCooldownTimer.start()

func _on_attack_cooldown_timer_timeout():
	can_attack = true


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.take_damage_p(1, self)
func take_damage(damage, body):
	health -=1
	var tween: Tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate",Color.TRANSPARENT,0.1)
	tween.tween_property($AnimatedSprite2D, "modulate",Color.WHITE,0.1)
	if health <=0:
		queue_free()
