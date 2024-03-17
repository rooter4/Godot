extends Sprite2D

@onready var whip_shader = preload("res://Scenes/new_shader.gdshader")

func add_slash():
	material.shader = null
