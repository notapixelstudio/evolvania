extends "state.gd"

var in_air_speed = 600
export (float) var MAX_FALL_SPEED = 3000

var jump_buffer = 0
var can_jump = false
var jumps = 0
func setup(actor, previous_state):
	jump_buffer = 0
	can_jump = false
	in_air_speed = get_node("../walk").speed
	match previous_state:
		"jump":
			in_air_speed = get_node("../jump").in_air_speed
			jumps = get_node("../jump").jumps
		"walk":
			in_air_speed = get_node("../walk").speed
	actor.emit_signal("perform_action", "fall")

func input_process(actor, event):
	
	if event.is_action_pressed(actor.right):
		actor.direction = 1
		actor.velocity.x = in_air_speed * actor.direction
	elif event.is_action_pressed(actor.left):
		actor.direction = -1
		actor.velocity.x = in_air_speed * actor.direction
	if event.is_action_released(actor.right):
		actor.direction = 1
		actor.velocity.x = 0
	elif event.is_action_released(actor.left):
		actor.direction = -1
		actor.velocity.x = 0
		
	if event.is_action_pressed(actor.jump):
		if jumps:
			actor.jump()
	
	if event.is_action_pressed(actor.dash):
		actor.dash()
	if event.is_action_released(actor.dash):
		in_air_speed = get_node("../walk").walk_speed

func process(actor, delta):
	jump_buffer = max(0, jump_buffer-delta)
	actor.velocity.y += actor.GRAVITY
	actor.velocity.y = min(actor.velocity.y, MAX_FALL_SPEED)
	
	if actor.is_on_wall():
		actor.wall_slide()
	
	if actor.is_processing_input():
		if Input.is_action_pressed(actor.right):
			actor.direction = 1
			actor.velocity.x = in_air_speed * actor.direction
		elif Input.is_action_pressed(actor.left):
			actor.direction = -1
			actor.velocity.x = in_air_speed * actor.direction
		
		if Input.is_action_just_pressed(actor.jump):
			jump_buffer = actor.JUMP_BUFFER
			
	if actor.is_on_floor():
		if jump_buffer > 0:
			print("YOU CAN JUMP ON TIME")
			actor.jump()
			return
		if actor.is_processing_input():
			if Input.is_action_pressed(actor.right):
				actor.direction = 1
				actor.walk()
			elif Input.is_action_pressed(actor.left):
				actor.direction = -1
				actor.walk()
			else:
				actor.idle()
		else:
			actor.idle()
