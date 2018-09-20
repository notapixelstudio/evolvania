extends "state.gd"
var this_actor 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func setup(actor, previous_state):
	actor.get_node("Camera2D").current = true
	this_actor = actor
	
# Called when the node enters the scene tree for the first time.
func clear():
	this_actor.get_node("Camera2D").current = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
