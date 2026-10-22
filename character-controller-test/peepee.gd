extends CharacterBody2D

var gravity = 5
var horizontal_speed = 250 
var x_direction = 1
enum animation_states {IDLE, MOVING, JUMPING, IN_AIR}
var animation_state = animation_states.IDLE: set = set_animation_state
enum states {GROUND, AIR}
var state = states.AIR: set = set_state
var horizontal_acceleration = 500
var friction = 1000.0
var jump_force = 200
var coyote = .2
var short_jump = 1.5
var horizontal_air_speed = 250
var horizontal_air_friction = 1000
var double_jump = false


func _ready() -> void:
	
	gravity = Globals.friction
	horizontal_speed = Globals.horizontal_speed 
	horizontal_acceleration = Globals.horizontal_acceleration
	friction = Globals.friction
	jump_force = Globals.jump_force
	$coyote_timer.wait_time = Globals.coyote
	short_jump = Globals.short_jump
	horizontal_air_speed = Globals.horizontal_air_speed
	horizontal_air_friction = Globals.horizontal_air_friction
	double_jump = Globals.double_jump
	
func change_value(name,val):
	
	match name:
		'gravity':
			gravity = val
		'coyote':
			$coyote_timer.wait_time = val
		'horizontal_speed':
			horizontal_speed = val
		'horizontal_acceleration':
			horizontal_acceleration = val
		'jump':
			jump_force = val
		'short_jump':
			short_jump = val
		'friction':
			friction = val
		'horizontal_air_speed':
			horizontal_air_speed = val
		'horizontal_air_friction':
			horizontal_air_friction = val
		'double_jump':
			double_jump = val
		
		Globals.set_value(name,value)
		
			


func _physics_process(delta: float) -> void:
	
	x_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity.x = x_direction * horizontal_acceleration
	if x_direction != 0:
		if x_direction == 1:
			$Sprite2D.flip_h = true
		elif x_direction == -1:
			$Sprite2D.flip_h = false
		
		if state == states.GROUND:
			velocity.x = clamp(velocity.x,-horizontal_speed,horizontal_speed)
		elif state == states.AIR:
			velocity.x = clamp(velocity.x,-horizontal_air_speed,horizontal_air_speed)
	else:
		if state == states.GROUND:
			velocity.x = lerp(velocity.x,0.0,friction)
		elif state == states.AIR:
			velocity.x = lerp(velocity.x,0.0,horizontal_air_friction)
		
	
	if state == states.GROUND:
	
		if is_on_floor() == false:
			$coyote_timer.start()
			
			
		elif velocity.x != 0:
			animation_state = animation_states.MOVING
		
		else:
		
			animation_state = animation_states.IDLE
		
		if Input.is_action_just_pressed("jump"):
			
			state = states.AIR
			animation_state = animation_states.JUMPING
			

	if state == states.AIR:
		
		if is_on_floor() and animation_state != animation_states.JUMPING and velocity.y >= 0:
			state = states.GROUND
			animation_state = animation_states.IDLE
			
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y /= short_jump
		
		if Input.is_action_just_pressed("jump"):
			if double_jump == true:
				velocity.y -= jump_force
				
		
		
		velocity.y += gravity

	move_and_slide()

func set_animation_state(new_state):
	
	if animation_state != new_state:
		animation_state = new_state
		if animation_state == animation_states.JUMPING:
			
			$AnimationPlayer.play("jump")
		elif animation_state == animation_states.MOVING:
			$AnimationPlayer.play("running")
		elif animation_state == animation_states.IDLE:
			$AnimationPlayer.play("idle")
		
func set_state(new_state):
	if state != new_state:
		state = new_state
		if state == states.GROUND:
			velocity.y = 0

func _on_animation_player_animation_finished(anim_name: StringName) -> void:

	if anim_name == 'jump':
		velocity.y -= jump_force
		animation_state = animation_states.IDLE
		


func _on_coyote_timer_timeout() -> void:
	state = states.AIR
	animation_state = animation_states.IDLE
