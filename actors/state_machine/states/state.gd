extends Node

export (NodePath) var state_machine = "../"

func _ready():
	set_process_input(false)
	set_process(true)
	set_physics_process(false)
	
func process(actor, delta):
	pass
	
func input_process(actor, event):
	pass
	
func setup(actor, previous_state):
	clear()
	
func clear():
	set_process_input(false)
	set_process(false)
	set_physics_process(false)
	