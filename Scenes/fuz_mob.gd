extends CharacterBody2D

var SPEED = 100.0
const JUMP_VELOCITY = -600.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_node("/root/Game/player")
var canJump = true
var rand = RandomNumberGenerator.new()
var health = 3
var mana = 10
signal death(position)


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
func take_damage(damage, body):
	SPEED = 0
	print("hit")
	death.emit(global_position)
	self.queue_free()

func _on_damage_area_body_entered(body):
	if body.name == "player":
		body.take_damage_p(1,self)
		var dir = global_position.direction_to(body.global_position)
		dir = dir.normalized().snapped(Vector2.ONE)
		print(str(dir))
		var exp_force = dir *800
		print(str(exp_force))
		velocity.x = exp_force.x *-1
		velocity.y = exp_force.y /2 * -1
		var tween: Tween = create_tween()
		tween.tween_property($AnimatedSprite2D, "modulate",Color.TRANSPARENT,0.1)
		tween.tween_property($AnimatedSprite2D, "modulate",Color.WHITE,0.1)
		move_and_slide()
