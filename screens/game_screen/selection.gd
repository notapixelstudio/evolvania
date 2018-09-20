extends "res://actors/state_machine/states/state.gd"
var children = []
var index = 0
func setup(actor, previous_state):
	for n in actor.get_children():
		if n.is_in_group("player"):
			children.append(n)
			n.set_process_input(false)
			n.add_state("selected")
	actor.emit_signal("perform_action", name)
	print(children)
	children[index].set_state("selected")
	children[index].get_node("Camera2D").current = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func mod(a,b):
	var ret = a%b
	if ret < 0: 
		return ret+b
	else:
		return ret
		
func input_process(actor, event):
	if event.is_action_pressed("ui_left"):
		children[index].idle()
		children[index].get_node("Camera2D").current = false
		index = mod(index - 1, len(children))
		children[index].set_state("selected")
		children[index].get_node("Camera2D").current = true
	if event.is_action_pressed("ui_right"):
		children[index].idle()
		children[index].get_node("Camera2D").current = false
		index = mod(index + 1, len(children))
		children[index].set_state("selected")
		children[index].get_node("Camera2D").current = true
	if event.is_action_pressed("ui_select"):
		actor.state_machine.set_state("play")
		children[index].set_process_input(true)
		children[index].idle()
		children[index].get_node("Camera2D").current = true