extends "platform_actor.gd"

export (String) var left = "ui_left"
export (String) var right = "ui_right"
export (String) var up = "ui_up"
export (String) var down = "ui_down"
export (String) var jump = "ui_select"
export (String) var dash = "ui_cancel"

var current_states = []

func _ready():
	set_process_input(false)
	for s in state_machine.get_children():
		current_states.append(s.name)
	
#  Questa non dovrebbe essere chiamata
func _input(event):
	state_machine.state.input_process(self, event)
	print("VERO?")

func _on_change_state_timeout():
	direction = rand_range(-1,1)
	var random_choice = randi() % len(current_states)
	var random_state = current_states[random_choice]
	print("FAKE -> "+ random_state, " ", direction)
	propagate_call(random_state)
	yield(get_tree().create_timer(0.3), "timeout")
	idle()
