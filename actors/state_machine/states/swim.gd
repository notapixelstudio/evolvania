extends "state.gd"

var swim_speed = 400

func setup(actor, previous_state):
	actor.emit_signal("perform_action", "swim")

func input_process(actor, event):
	if event.is_action_pressed(actor.right):
		actor.direction = 1
		actor.velocity.x = swim_speed * actor.direction
	elif event.is_action_pressed(actor.left):
		actor.direction = -1
		actor.velocity.x = swim_speed * actor.direction
		
	if event.is_action_pressed(actor.up):
		actor.velocity.y = -swim_speed
	elif event.is_action_pressed(actor.down):
		actor.velocity.y = swim_speed
		
	if event.is_action_released(actor.right):
		actor.direction = 1
		actor.velocity.x = 0
	elif event.is_action_released(actor.left):
		actor.direction = -1
		actor.velocity.x = 0

	if event.is_action_released(actor.up):
		actor.velocity.y = 0
	elif event.is_action_released(actor.down):
		actor.velocity.y = 0		
	#if event.is_action_pressed(actor.jump):
	#	actor.jump()
	
func process(actor, delta):
	if actor.velocity.y > -100:
		actor.velocity.y = min(0, actor.velocity.y - actor.GRAVITY)
		
	if actor.is_on_wall():
		actor.wall_slide()
		
	if actor.is_processing_input():
		if Input.is_action_pressed(actor.right):
			actor.direction = 1
			actor.velocity.x = swim_speed * actor.direction
		elif Input.is_action_pressed(actor.left):
			actor.direction = -1
			actor.velocity.x = swim_speed * actor.direction
			
		if Input.is_action_pressed(actor.up):
			actor.velocity.y = -swim_speed
		elif Input.is_action_pressed(actor.down):
			actor.velocity.y = swim_speed