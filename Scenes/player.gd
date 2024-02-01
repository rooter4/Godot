extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -700.0
signal health_change
signal energy_change
signal damaged
@onready var sprite_2d = $Sprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim_tree = $AnimationTree
@onready var state = anim_tree.get("parameters/playback")
@onready var ground_state = anim_tree.get("parameters/ground/playback")
@onready var air_state = anim_tree.get("parameters/air/playback")
@onready var camera = $ShakeCam
var canDouble = false
var direction
var canShoot = true
var canPound = true
var canDash = true
var dashing = false
var attack = false
var maxHealth = 10
var health = 5
var knockback = Vector2.ZERO
var can_take_damage = true


func _ready():
	$AnimationTree.active = true
	for i in health:
		health_change.emit()

func _physics_process(delta):
	
	if is_on_floor():
		state.travel("ground")
	
	
	# Add the gravity.
	if not is_on_floor() && not dashing:
		velocity.y += gravity * delta
		state.travel("air")
	elif dashing:
		velocity.y = 0
	else:
		canDouble = false
		canDash = true
		
	
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		ground_state.travel("running")
		print(str(direction))
		if(Input.is_action_just_pressed("ui_text_indent") && canDash):
			state.travel("dash")
			canDash = false
			print(str(direction))
			velocity.x = direction * SPEED *2
			$DashTimer.start()
			dashing = true
		elif not dashing:
			velocity.x = direction * SPEED
			ground_state.travel("running")
			sprite_2d.flip_h = direction < 0
			$Ponytail.scale.x = direction

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		ground_state.travel("idle")
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if(is_on_floor()):
			canDouble = true
			velocity.y = JUMP_VELOCITY
		elif canDouble:
			velocity.y = JUMP_VELOCITY
			canDouble = false
			air_state.travel("double")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	if Input.is_action_just_pressed("ui_up"):
		health_change.emit()
		
	if Input.is_action_just_pressed("ui_page_up") && is_on_floor():
		pound()
	
	if Input.is_action_just_pressed("ui_page_down"):
		shoot()
	if(Input.is_action_pressed("ui_end")):
		attack = true
	else:
		attack = false
	

	move_and_slide()
	knockback = lerp(knockback,Vector2.ZERO,0.1)

func shoot():
	if(canShoot):
		const BOLT = preload("res://Scenes/Attacks/bolt.tscn")
		var new_bolt = BOLT.instantiate()
		get_parent().add_child(new_bolt)
		new_bolt.transform = global_transform
		new_bolt.global_position.y +=16
		new_bolt.global_position.x +=5
		new_bolt.flip(sprite_2d.flip_h)
		
		canShoot=false
		$Timer.start()
		
func pound():
	if(canPound):
		energy_change.emit()
		canPound = false
		const POUND = preload("res://Scenes/Attacks/pound.tscn")
		var new_pound = POUND.instantiate()
		add_child(new_pound)
		canPound = false
		$ShakeCam.add_trauma(.5)
		$CooldownTimer.start()

func _on_timer_timeout():
	canShoot = true

func _on_dash_timer_timeout():
	dashing = false
	state.travel("idle")

func _on_cooldown_timer_timeout():
	canPound = true
func take_damage_p(amount, body):
	if(can_take_damage):
		can_take_damage = false
		$DamageCooldown.start()
		health -=1
		damaged.emit()
		var dir = global_position.direction_to(body.global_position)
		dir = dir.normalized().snapped(Vector2.ONE)
		print(str(dir))
		var exp_force = dir *800
		print(str(exp_force))
		velocity.x = exp_force.x *-1
		velocity.y = exp_force.y /2 * -1
		var tween: Tween = create_tween()
		tween.tween_property($Sprite2D, "modulate",Color.TRANSPARENT,0.1)
		tween.tween_property($Sprite2D, "modulate",Color.WHITE,0.1)
		move_and_slide()



func _on_damage_cooldown_timeout():
	can_take_damage = true
