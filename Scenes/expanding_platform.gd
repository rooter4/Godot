extends StaticBody2D
signal animation_complete
@onready var sprite_player = $Sprite

func play_animation():
	$Sprite.play("default")


func _on_sprite_frame_changed():
	if $Sprite.frame == 7:
		animation_complete.emit()
