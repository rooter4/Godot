extends Area2D

@onready var bolt_sprite = $AnimatedSprite2D
@onready var anim_position = global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.

var speed = 200
func _process(delta):
	global_position.x += speed * delta

func flip(flip_h):
	$AnimatedSprite2D.flip_h = flip_h
	if flip_h: speed = -speed

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if(body.name != "Player"):
		$AnimatedSprite2D.play("splash")
		set_process(false)
	if body.has_method("take_damage"):
		body.take_damage(1, self)
		queue_free()

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.get_animation() == "splash":
		queue_free()
