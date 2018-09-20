extends Node

var state_machine
var debug = false
onready var DebugNode = get_node("DebugNode")

signal perform_action
func _ready():
	state_machine = $state_machine
	state_machine.set_state("selection")
	# random generating AI guys
	#for i in rand_range(3, 10):
	#	var d = load("res://actors/AIWithState.tscn").instance()
	#	d.position = $AI.position + Vector2(rand_range(-200, 200), rand_range(-200, 200))
	#	add_child(d)
	
	# Create three heroes and make them selectable
	# develop the Hero
	$Content/Hero.develop()
	
func _input(event):
	state_machine.state.input_process(self, event)
	
	var debug_pressed = event.is_action_pressed("debug")
	if debug_pressed:
		debug = not debug
		DebugNode.visible = debug

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
