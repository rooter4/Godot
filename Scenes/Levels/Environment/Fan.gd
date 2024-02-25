extends AnimatableBody2D

func interact(body):
	body.take_damage_p(1,self)
	return 0.0
