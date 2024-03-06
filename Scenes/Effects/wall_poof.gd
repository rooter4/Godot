extends AnimatedSprite2D

@onready var anim_position = global_position

func _process(delta):
	global_position = anim_position

func _on_animation_finished():
	queue_free()
