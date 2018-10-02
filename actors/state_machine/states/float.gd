extends "state.gd"

func setup(actor, previous_state):
	actor.velocity.y = 0
	actor.emit_signal("perform_action", "idle")
	
func input_process(actor, event):
	if event.is_action_pressed(actor.jump):
		actor.jump()
	
	if event.is_action_pressed(actor.right):
		actor.direction = 1
		actor.walk()
	elif event.is_action_pressed(actor.left):
		actor.direction = -1
		actor.walk()
		
	if event.is_action_pressed(actor.dash):
		actor.dash()
	