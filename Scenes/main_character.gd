extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -700.0
@onready var sprite_2d = $Sprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim_tree = $AnimationTree
@onready var state = anim_tree.get("parameters/playback")
@onready var camera = $ShakeCam
var canDouble = false
var direction
var canShoot = true
var canPound = false

func _physics_process(delta):
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	else:
		canDouble = false
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if(is_on_floor()):
			canDouble = true
			velocity.y = JUMP_VELOCITY
			anim_tree["parameters/conditions/is_double"] = false
		elif canDouble:
			velocity.y = JUMP_VELOCITY
			canDouble = false
			anim_tree["parameters/conditions/is_double"] = true

	
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if(Input.is_action_pressed("ui_down")):
		anim_tree["parameters/conditions/slam"] = true
		velocity.y = - JUMP_VELOCITY
		velocity.x = 0
		canPound = true
		if(is_on_floor() && state.get_current_node() == "slam"):
			pound()
	if(Input.is_action_just_released("ui_down")):
		anim_tree["parameters/conditions/slam"] = false
		canPound = false
	
	
		
	if Input.is_action_just_pressed("ui_page_down"):
		shoot()
	
	update_animation()
	move_and_slide()
	
	
	
	
		
	
func update_animation():
	
	
	
	
	if(velocity.x < -1 || velocity.x >1):
		anim_tree["parameters/conditions/idle"] = false
		anim_tree["parameters/conditions/is_moving"] = true
	else:
		anim_tree["parameters/conditions/is_moving"] = false
		anim_tree["parameters/conditions/idle"] = true
	if(velocity.y < -1):
		anim_tree["parameters/conditions/jump"] = true
		anim_tree["parameters/conditions/falling"] = false
		
	elif(velocity.y >1):
		anim_tree["parameters/conditions/falling"] = true
		anim_tree["parameters/conditions/jump"] = false
		
	if(is_on_floor()):
		anim_tree["parameters/conditions/on_floor"] = true
		anim_tree["parameters/conditions/falling"] = false
	else:
		anim_tree["parameters/conditions/on_floor"] = false
		
	if(state.get_current_node()=="double"):
		anim_tree["parameters/conditions/is_double"] = false

func shoot():
	if(canShoot):
		print("shoot")
		const BOLT = preload("res://Scenes/bolt.tscn")
		var new_bolt = BOLT.instantiate()
		add_child(new_bolt)
		new_bolt.global_position = global_position
		new_bolt.global_position.y +=25
		new_bolt.flip(sprite_2d.flip_h)
		canShoot=false
		$Timer.start()
		
func pound():
	if(canPound):
		print("pound")
		const POUND = preload("res://Scenes/pound.tscn")
		var new_pound = POUND.instantiate()
		
		print(str(global_position) + " : " + str(position))
		
		
		
		add_child(new_pound)
		canPound = false
		$ShakeCam.add_trauma(.5)


func _on_timer_timeout():
	canShoot = true
