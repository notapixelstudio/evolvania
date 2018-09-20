extends KinematicBody2D

var direction = 1 setget set_direction
var velocity = Vector2(0, 0) setget set_velocity

var state_machine = null
var starting_state = "idle"

export (float) var GRAVITY = 50
export (Vector2) var FLOOR_NORMAL = Vector2(0, -1)
export (float) var SLOPE_STOP_SPEED = 200
export (float) var SLOPE_MAX_DEGREE = 46
export (float) var FALL_THRESHOLD = 100

export (bool) var can_dash = true

export (Dictionary) var dna = {
	'genotype': {
		'long-living': false,
		'fecund': false,
		'charming': false,
		'horn': false,
		'wings': false,
		'gills': false,
		'scales': false
	},
	'phenotype': {
		'long-living': false,
		'fecund': false,
		'charming': false,
		'horn': false,
		'gills': false,
		'scales': false
	}
}

signal enter_state(state)
signal perform_action(action)
signal action_performed(action)
signal direction_changed(new_direction)

func set_velocity(value):
	velocity = value

func set_direction(value):
	direction = value
	emit_signal("direction_changed", value)

# add a node, specified by its script gd in the actor state_machine
func add_state(state_name):
	if state_machine.get_node(state_name):
		return false
	var new_state = load("res://actors/state_machine/states/"+state_name+".gd").new()
	state_machine.add_child(new_state)
	new_state.name=state_name
	return true
	
# in case we need to remove it.
func remove_state(state_name):
	var state_to_remove = state_machine.get_node("state_name")
	state_machine.remove_child(state_to_remove)
	return true
	
func set_state(new_state):
	# set state only if it is present
	if state_machine.get_node(new_state):
		state_machine.state = new_state
	else:
		print("you cannot "+ new_state)
	
func get_state():
	return state_machine.state
	
func read_state(name):
	return state_machine.get_node(name)
	
func climb():
	set_state("climb")

func dash():
	if not can_dash:
		return
	set_state("dash")

func die():
	set_state("dead")
	
func jump():
	set_state("jump")
		
func cancel_jump():
	velocity.y = 0
	
func fall():
	set_state("fall")
	
func walk():
	set_state("walk")
	
func idle():
	set_state("idle")
	
func wall_slide():
	set_state("wall")
	
func stop():
	emit_signal("action_performed", "stop")

func _ready():
	for trait in $Traits.get_children():
		if not dna['phenotype'][trait.name]:
			trait.queue_free()
			
	
	state_machine = $state_machine
	set_state(starting_state)
	
func _physics_process(delta):
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	state_machine.state.process(self, delta)
	
func zone_entered(type):
	if type == 'lava':
		if not dna['phenotype']['scales']:
			die()
		# FIXME touching lava when having scales should have an effect
	elif type == 'water':
		if dna['phenotype']['gills']:
			print('TODO call a method that makes the hero enter the water state')
		else:
			die()
	
func zone_exited(type):
	if type == 'water':
		print('TODO call a method that makes the hero exit the water state')
	