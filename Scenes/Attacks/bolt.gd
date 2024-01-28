extends Area2D

@onready var bolt_sprite = $BoltSprite
@onready var anim_position = global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.

var speed = 10
func _process(delta):
	
	global_position.x += speed
	
	
	
func flip(flip_h):
	bolt_sprite.flip_h = flip_h
	if flip_h: speed = -speed


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
		queue_free()
