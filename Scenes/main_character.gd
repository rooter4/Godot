extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -700.0
signal health_change
signal energy_change
@onready var sprite_2d = $Sprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim_tree = $AnimationTree
@onready var state = anim_tree.get("parameters/Air/playback")
@onready var camera = $ShakeCam
var canDouble = false
var direction
var canShoot = true
var canPound = true
var canDash = true
var dashing = false
var attack = false

func _physics_process(delta):
		
	
	# Add the gravity.
	if not is_on_floor() && not dashing:
		velocity.y += gravity * delta
	elif dashing:
		velocity.y = 0
	else:
		canDouble = false
		canDash = true
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if(is_on_floor()):
			canDouble = true
			velocity.y = JUMP_VELOCITY
			anim_tree["parameters/Air/conditions/is_double"] = false
		elif canDouble:
			velocity.y = JUMP_VELOCITY
			canDouble = false
			anim_tree["parameters/Air/conditions/is_double"] = true

		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if(Input.is_action_just_pressed("ui_text_indent") && canDash):
			canDash = false
			velocity.x = direction * SPEED *2
			$DashTimer.start()
			dashing = true
		elif not dashing:
			velocity.x = direction * SPEED
			sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_up"):
		health_change.emit()
		
	if Input.is_action_just_pressed("ui_page_up") && is_on_floor():
		pound()
	
	if Input.is_action_just_pressed("ui_page_down"):
		shoot()
	if(Input.is_action_just_pressed("ui_end")):
		attack = true
	else:
		attack = false
	
	update_animation()
	move_and_slide()

	
func update_animation():
	
	
	
	
	if(velocity.x > SPEED || velocity.x < -SPEED):
		anim_tree["parameters/conditions/dash"] = true
	elif(velocity.x < -1 || velocity.x >1):
		anim_tree["parameters/Ground/conditions/idle"] = false
		anim_tree["parameters/Ground/conditions/is_moving"] = true
	else:
		anim_tree["parameters/Ground/conditions/is_moving"] = false
		anim_tree["parameters/Ground/conditions/idle"] = true
	
	if(velocity.y > -JUMP_VELOCITY):
		anim_tree["parameters/Air/conditions/slam"] = true

	elif(velocity.y < -1):
		anim_tree["parameters/conditions/jump"] = true
		anim_tree["parameters/Air/conditions/falling"] = false
		anim_tree["parameters/Air/conditions/slam"] = false
	elif(velocity.y >1):
		anim_tree["parameters/Air/conditions/falling"] = true
		anim_tree["parameters/conditions/jump"] = false
		anim_tree["parameters/Air/conditions/slam"] = false
		
	if(is_on_floor()):
		anim_tree["parameters/conditions/on_floor"] = true
		anim_tree["parameters/Air/conditions/falling"] = false
		anim_tree["parameters/Air/conditions/slam"] = false
	else:
		anim_tree["parameters/conditions/on_floor"] = false
		
	if(state.get_current_node()=="double"):
		anim_tree["parameters/Air/conditions/is_double"] = false
	if(state.get_current_node()=="dash"):
		anim_tree["parameters/conditions/dash"] = false
		
	if(attack):
		anim_tree["parameters/conditions/attack"] = true
	else:
		anim_tree["parameters/conditions/attack"] = false
	

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
	anim_tree["parameters/conditions/dash"] = false


func _on_cooldown_timer_timeout():
	canPound = true

