extends "res://actors/state_machine/states/state.gd"
var children = []
var index = 0

var this_actor


func setup(actor, previous_state):
	this_actor = actor
	actor.get_parent().get_node('CanvasLayer/Interface/Bars').visible = false
	
	children = []
	index=0
	for n in actor.get_children():
		if n.is_in_group("player"):
			children.append(n)
			n.set_process_input(false)
			n.add_state("selected")
	actor.emit_signal("perform_action", name)
	if len(children) <= 0 :
		actor.get_parent().game_over()
		return
	actor.get_parent().get_node("CanvasLayer/Istructions").text = str(len(children)) + " lives left."
	actor.get_parent().get_node("CanvasLayer/Istructions").visible = true
	children[index].set_state("selected")
	children[index].get_node("Camera2D").current = true

func clear():
	this_actor.get_parent().get_node('CanvasLayer/Interface/Bars').visible = true
	
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
		index = mod(index - 1, len(children))
		children[index].set_state("selected")
	if event.is_action_pressed("ui_right"):
		children[index].idle()
		index = mod(index + 1, len(children))
		children[index].set_state("selected")
	if event.is_action_pressed("ui_select"):
		children[index].set_process_input(true)
		children[index].idle()
		children[index].get_node("Camera2D").current = true
		children[index].connect("dead", actor, "on_player_death")
		children[index].connect("collect", actor, "on_collect_gems")		
		global.this_player = children[index]
		actor.state_machine.set_state("play")