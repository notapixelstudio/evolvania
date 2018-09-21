extends "state.gd"
var this_actor 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func setup(actor, previous_state):
	actor.get_node("Camera2D").current = true
	actor.get_node("arrow").visible = true
	var traits = actor.get_node("traits")
	traits.text = ""
	for trait in actor.dna["phenotype"]:
		if actor.dna["phenotype"][trait]:
			traits.text += trait +"\n"
	actor.get_node("traits").visible = true
	this_actor = actor
	
# Called when the node enters the scene tree for the first time.
func clear():
	this_actor.get_node("arrow").visible = false
	this_actor.get_node("traits").visible = false
	this_actor.get_node("Camera2D").current = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
