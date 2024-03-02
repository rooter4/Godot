extends StaticBody2D
var velo = Vector2(100,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$RayCast2D.is_colliding() or !$RayCast2D2.is_colliding():
		velo = -velo
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
	translate(velo * delta)
func interact(body):
	body.take_damage_p(1,self)
	return 0.0
