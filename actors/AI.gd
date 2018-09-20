extends "platform_actor.gd"

export (String) var left = "ui_left"
export (String) var right = "ui_right"
export (String) var up = "ui_up"
export (String) var down = "ui_down"
export (String) var jump = "ui_select"
export (String) var dash = "ui_cancel"

var current_states = []
signal copulate(player)

func _ready():
	set_process_input(false)
	for s in state_machine.get_children():
		current_states.append(s.name)
	
	set_state("chilling")
	
#  Questa non dovrebbe essere chiamata
func _input(event):
	state_machine.state.input_process(self, event)

func _on_change_state_timeout():
	direction = rand_range(-1,1)
	var random_choice = randi() % len(current_states)
	var random_state = current_states[random_choice]
	propagate_call(random_state)
	yield(get_tree().create_timer(0.3), "timeout")
	idle()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.set_process_input(false)
		body.set_state("chilling")
		body.remove_from_group("player")
		emit_signal("copulate", [body])
		disconnect("body_entered", self, "_on_Area2D_body_entered")


func _on_Area2D_body_exited(body):
	pass # Replace with function body.
