extends Node

var state_machine
var debug = false
onready var DebugNode = get_node("DebugNode")

var last_checkpoint = Vector2(185, 720)
signal perform_action
signal update_time(value)
signal update_counter(value)
signal reset_lifebar(value)

var player = preload("res://actors/HeroWithState.tscn")
var this_player
var collected_gems = 0

func _ready():
	# create first three heroes
	for i in range(0, 3):
		var p = player.instance()
		p.position = last_checkpoint + Vector2(60, 0)*i
		p.add_to_group("player")
		$Content.add_child(p)
	state_machine = $state_machine
	state_machine.set_state("selection")
	# random generating AI guys
	#for i in rand_range(3, 10):
	#	var d = load("res://actors/AIWithState.tscn").instance()
	#	d.position = $AI.position + Vector2(rand_range(-200, 200), rand_range(-200, 200))
	#	add_child(d)
	
	# Create three heroes and make them selectable
	# develop the Hero
	#$Hero.develop()
	
func _input(event):
	state_machine.state.input_process(self, event)
	
	var debug_pressed = event.is_action_pressed("debug")
	if debug_pressed:
		debug = not debug
		DebugNode.visible = debug

func on_player_death():
	state_machine.set_state("selection")

func new_checkpoint(checkpoint_node):
	return checkpoint_node.position

func _on_AI_copulate(player):
	var node_to_eliminate = []
	for n in $Content.get_children():
		if n.is_in_group("player"):
			n.remove_from_group("player")
			node_to_eliminate.append(n)
	last_checkpoint = player[0].position
	create_children()
	player[0].queue_free()
	state_machine.set_state("selection")
	for node in node_to_eliminate:
		node.queue_free()
	
func create_children():
	for i in range(0, 3):
		var p = player.instance()
		p.position = last_checkpoint + Vector2(60, 0)*i
		p.add_to_group("player")
		$Content.add_child(p)
		
func game_over():
	get_tree().change_scene_to(load("res://screens/gameover_screen/GameOver.tscn"))

func _on_Timer_timeout():
	emit_signal("update_time", global.this_player.get_node("life_span").get_time_left())

func reactivate_timer():
	var this_value = global.this_player.life_span
	global.this_player.get_node("life_span").wait_time = global.this_player.life_span
	emit_signal("reset_lifebar", this_value)
	# emit_signal("update_time", global.this_player.get_node("life_span").get_time_left())
	
func on_collect_gems():
	collected_gems += 1
	emit_signal("update_counter", collected_gems)