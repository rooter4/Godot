extends CharacterBody2D

var SPEED = 100.0
const JUMP_VELOCITY = -600.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_node("/root/Game/main_character")
var canJump = true
var rand = RandomNumberGenerator.new()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var direction = global_position.direction_to(player.global_position)
	velocity.x = direction.x * SPEED
	play_walk()
	
	if global_position.distance_to(player.global_position) <100 && canJump:
		velocity.y = JUMP_VELOCITY
		canJump = false
		$JumpTimer.start()
		
	move_and_slide()
	
func play_walk():
	$AnimatedSprite2D.animation = "walking"


func _on_jump_timer_timeout():
	canJump = true
func take_damage():
	SPEED = 0
	print("hit")
	particles_emit()
	$ParticleTimer.start()
	$AnimatedSprite2D.visible = false
	$CollisionShape2D.disabled = true
	

func particles_emit():

	const PART = preload("res://Scenes/Effects/particle.tscn")
	for i in 2:
		var new_particle = PART.instantiate()
		new_particle.linear_velocity.y = randf_range(JUMP_VELOCITY, 0)
		new_particle.angular_velocity = randf_range(0,20)
		add_child(new_particle)
	



func _on_particle_timer_timeout():
	queue_free()
