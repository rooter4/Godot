extends StaticBody2D
signal animation_complete
@onready var sprite_player = $Sprite

func play_animation():
	$Sprite.play("default")


func _on_sprite_animation_finished():
	print("anim here")
	animation_complete.emit()
