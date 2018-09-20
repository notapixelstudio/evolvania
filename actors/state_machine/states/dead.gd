extends "state.gd"
var this_actor 
signal player_dead
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func setup(actor, previous_state):
	actor.velocity = Vector2(0,0)
	actor.remove_from_group("player")
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("player_dead")
	actor.queue_free()
	
# Called when the node enters the scene tree for the first time.
func clear():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
