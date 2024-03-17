extends CharacterBody2D

const SPEED = 15.0
const MAX_SPEED = 100
const FRICTION = 7
const JUMP_VELOCITY = -300.0
const DOUBLE_JUMP_VELOCITY = -150
signal health_change
signal energy_change
signal damaged
signal energy_used
@onready var sprite_2d = $Sprite2D
const JUMP_POOF = preload("res://Scenes/Effects/JumpPoof.tscn")
const DOUBLE_POOF = preload("res://Scenes/Effects/DoublePoof.tscn")
const WALL_POOF = preload("res://Scenes/Effects/wall_poof.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim_tree = $AnimationTree
@onready var state = anim_tree.get("parameters/playback")
@onready var ground_state = anim_tree.get("parameters/ground/playback")
@onready var air_state = anim_tree.get("parameters/air/playback")
@onready var camera = $ShakeCam
var can_double = false
var direction
var can_shoot = true
var can_pound = true
var can_dash = true
var dashing = false
var max_health = 10
var health = 5
var max_energy = 10
var energy = 5
var knockback = Vector2.ZERO
var can_take_damage = true
var coyote_frames = 15
var coyote = false
var last_floor
var can_move = true
var can_wall_jump = false
var jumping = false
var wall_jump = false

func _ready():
	$AnimationTree.active = true
	health_change.emit(health)
	energy_change.emit(energy)
	$CoyoteTimer.wait_time = coyote_frames/60.0
	

func _physics_process(delta):
	if is_on_floor():
		state.travel("ground")
		can_dash = true
		jumping = false
		coyote = false
		can_wall_jump = true
	else:
		state.travel("air")
		
	if is_on_wall_only():
		air_state.travel("wall")
		
	handle_jump()
	
	if dashing:
		velocity.y = 0
	else:
		velocity.y += gravity * delta
	
	#Left/Right and Dash input
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		ground_state.travel("running")
		if(Input.is_action_just_pressed("ui_text_indent")):
			handle_dash()
		elif not dashing:
			
			if velocity.x > -MAX_SPEED and velocity.x < MAX_SPEED:
				velocity.x += direction * SPEED
			ground_state.travel("running")
			sprite_2d.flip_h = direction < 0
			$Ponytail.scale.x = direction
	else:
		ground_state.travel("idle")
	velocity.x = move_toward(velocity.x, 0, FRICTION)
		
		

	if Input.is_action_just_pressed("ui_page_up") && is_on_floor():
		pound()
	if Input.is_action_just_pressed("ui_page_down"):
		shoot()
	if(Input.is_action_pressed("ui_end")):
		whip()
		

	if velocity.y < -980:
		velocity.y = -980
	last_floor = is_on_floor()
	

	move_and_slide()
	if !is_on_floor() and last_floor and !jumping:
		coyote = true
		$CoyoteTimer.start()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		
		if collision.get_collider().has_meta("interact"):
			var wait_time = collision.get_collider().interact(self)
			if(wait_time > 0.0):
				$PauseTimer.wait_time = wait_time
				$PauseTimer.start()
				_pause()
			break
		elif collision.get_collider().name == "Damage":
			take_damage_p(max_health,self)
			
	
	knockback = lerp(knockback,Vector2.ZERO,0.1)

func handle_jump():
	var check_double = get_parent().call("ability_check","ability_double")
	var check_wall= get_parent().call("ability_check","ability_wall_jump")
	wall_jump = false
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote:
			var jump_poof = JUMP_POOF.instantiate()
			add_child(jump_poof)
			can_double = true
			velocity.y = JUMP_VELOCITY
			jumping = true
		elif is_on_wall_only() and can_wall_jump and check_wall:
			velocity.y = JUMP_VELOCITY
			can_wall_jump = false
			velocity.x = -get_wall_normal().x * JUMP_VELOCITY/3
			var wall_poof = WALL_POOF.instantiate()
			wall_poof.flip_h = $Sprite2D.flip_h
			add_child(wall_poof)
		elif not is_on_floor() and can_double and check_double and not coyote:
			velocity.y = DOUBLE_JUMP_VELOCITY 
			can_double = false
			var double_poof  = DOUBLE_POOF.instantiate()
			add_child(double_poof)
			
func handle_dash():
	var check = get_parent().call("ability_check","ability_dash")
	if can_dash and check:
		state.travel("dash")
		can_dash = false
		velocity.x = direction * SPEED *20
		$DashTimer.start()
		dashing = true
		
		

func shoot():
	var check = get_parent().call("ability_check","ability_shoot")
	if(can_shoot and check):
		
		const BOLT = preload("res://Scenes/Attacks/bolt.tscn")
		var new_bolt = BOLT.instantiate()
		get_parent().add_child(new_bolt)
		new_bolt.transform = global_transform
		new_bolt.global_position.y +=10
		new_bolt.flip(sprite_2d.flip_h)
		
		can_shoot=false
		$Timer.start()
		
func pound():
	var check = get_parent().call("ability_check","ability_pound")
	if(can_pound and energy != 0 and check):
		change_energy(-1)
		can_pound = false
		const POUND = preload("res://Scenes/Attacks/pound.tscn")
		var new_pound = POUND.instantiate()
		add_child(new_pound)
		can_pound = false
		$ShakeCam.add_trauma(.5)
		$CooldownTimer.start()
func whip():
	var check = get_parent().call("ability_check","ability_slash")
	if(check):
		state.travel("whip")
func _on_timer_timeout():
	can_shoot = true

func _on_dash_timer_timeout():
	dashing = false
	state.travel("idle")

func _on_cooldown_timer_timeout():
	can_pound = true
	
func take_damage_p(amount, body):
	if(can_take_damage):
		can_take_damage = false
		$DamageCooldown.start()
		health -=amount
		if(health > 0):
			health_change.emit(health)
			var dir = global_position.direction_to(body.global_position)
			dir = dir.normalized().snapped(Vector2.ONE)

			var exp_force = dir *200

			velocity.x = exp_force.x *-1
			velocity.y = exp_force.y /2 * -1
			var tween: Tween = create_tween()
			tween.tween_property($Sprite2D, "modulate",Color.TRANSPARENT,0.1)
			tween.tween_property($Sprite2D, "modulate",Color.WHITE,0.1)
			move_and_slide()
		else:
			state.travel("death")
			set_physics_process(false)
			

func _on_damage_cooldown_timeout():
	can_take_damage = true
func _pause():
	set_physics_process(false)
	hide()
func _on_pause_timer_timeout():
	set_physics_process(true)
	show()
func change_energy(number):
	energy += number
	if energy > max_energy:
		energy = max_energy
	if energy < 0:
		energy = 0
	energy_change.emit(energy)

func _on_coyote_timer_timeout():
	coyote = false

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "death":
		get_tree().reload_current_scene()
func add_ability(ability):
	get_parent().add_ability(ability)
	add_slash()
func add_slash():
	$Sprite2D.add_slash()
