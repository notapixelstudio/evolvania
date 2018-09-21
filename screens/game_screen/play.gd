extends "res://actors/state_machine/states/state.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func setup(actor, previous_state):
	actor.get_parent().reactivate_timer()
	actor.get_parent().get_node("CanvasLayer/Istructions").visible=false
	global.this_player.get_node("life_span").start()
	$Timer.start()

func clear(actor):
	$Timer.stop()
	global.this_player.get_node("life_span").stop()
