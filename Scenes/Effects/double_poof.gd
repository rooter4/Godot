extends Node2D
@onready var anim_position = global_position

func _process(delta):
	global_position = anim_position


func _on_animated_sprite_2d_animation_finished():
	print("que free")
	queue_free()
