extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const DOUBLE_JUMP_VELOCITY = -150
signal health_change
signal energy_change
signal damaged
signal energy_used
@onready var sprite_2d = $Sprite2D

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
var maxHealth = 10
var health = 5
var max_energy = 10
var energy = 5
var knockback = Vector2.ZERO
var can_take_damage = true

var can_move = true

func _ready():
	$AnimationTree.active = true
	health_change.emit(health)
	energy_change.emit(energy)
	

func _physics_process(delta):
	if(can_move):
	#Jump and gravity
		if is_on_floor():
			state.travel("ground")
			canDash = true
			if Input.is_action_just_pressed("ui_accept"):
				canDouble = true
				velocity.y = JUMP_VELOCITY
		elif not is_on_floor():
			state.travel("air")
			if Input.is_action_just_pressed("ui_accept") and canDouble:
				velocity.y = DOUBLE_JUMP_VELOCITY
				canDouble = false
			elif dashing:
				velocity.y = 0
			else:
				velocity.y += gravity * delta
		
		
		#Left/Right and Dash input
		direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			ground_state.travel("running")
			if(Input.is_action_just_pressed("ui_text_indent") && canDash):
				state.travel("dash")
				canDash = false

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

		if Input.is_action_just_pressed("ui_page_up") && is_on_floor():
			pound()
		if Input.is_action_just_pressed("ui_page_down"):
			shoot()
		if(Input.is_action_pressed("ui_end")):
			state.travel("whip")

		if velocity.y < -980:
			velocity.y = -980
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider().has_meta("interact"):
				print("interact")
				$PauseTimer.wait_time = collision.get_collider().interact(self)
				$PauseTimer.start()
				_pause()
				break
				
		
		knockback = lerp(knockback,Vector2.ZERO,0.1)
	else:
		$Sprite2D.visible = false

func shoot():
	if(canShoot):
		const BOLT = preload("res://Scenes/Attacks/bolt.tscn")
		var new_bolt = BOLT.instantiate()
		get_parent().add_child(new_bolt)
		new_bolt.transform = global_transform
		new_bolt.global_position.y +=9
		new_bolt.global_position.x +=5
		new_bolt.flip(sprite_2d.flip_h)
		
		canShoot=false
		$Timer.start()
		
func pound():
	if(canPound && energy != 0):
		change_energy(-1)
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
		health -=amount
		if(health > 0):
			health_change.emit(health)
			var dir = global_position.direction_to(body.global_position)
			dir = dir.normalized().snapped(Vector2.ONE)

			var exp_force = dir *800

			velocity.x = exp_force.x *-1
			velocity.y = exp_force.y /2 * -1
			var tween: Tween = create_tween()
			tween.tween_property($Sprite2D, "modulate",Color.TRANSPARENT,0.1)
			tween.tween_property($Sprite2D, "modulate",Color.WHITE,0.1)
			move_and_slide()
		else:
			get_tree().reload_current_scene()



func _on_damage_cooldown_timeout():
	can_take_damage = true

func _pause():
	can_move = false
	$Sprite2D.visible = false

func _on_pause_timer_timeout():
	can_move = true
	$Sprite2D.visible = true
func change_energy(number):
	energy += number
	if energy > max_energy:
		energy = max_energy
	if energy < 0:
		energy = 0
	energy_change.emit(energy)
	
