extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim_tree = $AnimationTree
@onready var state = anim_tree.get("parameters/playback")
@onready var camera = $ShakeCam
var canDouble = false

func _physics_process(delta):
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	else:
		canDouble = false
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") && state.get_current_node()!="pound":
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
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction && state.get_current_node()!="pound":
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if(Input.is_action_pressed("ui_down")):
		anim_tree["parameters/conditions/slam"] = true
		velocity.y = - JUMP_VELOCITY
		velocity.x = 0
		if(is_on_floor()):
				anim_tree["parameters/conditions/pound"] = true
				anim_tree["parameters/conditions/slam"] = false
		else:
			anim_tree["parameters/conditions/slam"] = false
		
	
	update_animation()
	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
	
		
	
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
	if(state.get_current_node()=="pound"):
		anim_tree["parameters/conditions/pound"] = false
