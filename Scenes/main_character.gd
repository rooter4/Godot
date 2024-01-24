extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	if (velocity.x >1 || velocity.x < -1):
		sprite_2d.animation ="running"
	elif (Input.is_action_pressed("ui_down") and is_on_floor()):
			sprite_2d.animation = "pound"
	else: 
		sprite_2d.animation = "idle"
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if(velocity.y < 0):
			sprite_2d.animation = "jumping"
		else:
			sprite_2d.animation = "falling"
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	
	
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite_2d.animation = "running"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
