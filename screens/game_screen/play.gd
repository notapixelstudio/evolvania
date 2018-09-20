extends "res://actors/state_machine/states/state.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func setup(actor, previous_state):
	actor.get_parent().reactivate_timer()
	global.this_player.get_node("life_span").start()
	$Timer.start($Timer.wait_time)

func clear():
	$Timer.stop()
