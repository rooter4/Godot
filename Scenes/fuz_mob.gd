extends CharacterBody2D

var SPEED = 100.0
const JUMP_VELOCITY = -600.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_node("/root/Game/main_character")
var canJump = true


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
	$DeathParticles.emitting = true


func _on_death_particles_finished():
	queue_free()
