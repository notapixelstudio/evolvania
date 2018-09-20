extends "platform_actor.gd"

export (String) var left = "ui_left"
export (String) var right = "ui_right"
export (String) var up = "ui_up"
export (String) var down = "ui_down"
export (String) var jump = "ui_select"
export (String) var dash = "ui_cancel"

signal dead

func handle_input():
	pass

func _input(event):
	if event.is_action_pressed("ui_action"):
		set_state("dead")
	state_machine.state.input_process(self, event)

func _on_dead_player_dead():
	emit_signal("dead")
