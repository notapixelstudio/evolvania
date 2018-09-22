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
		
		if i == 0:
			p.dna['phenotype']['wings'] = true
			p.dna['genotype']['fecund'] = true
		elif i == 1:
			p.dna['phenotype']['alluring'] = true
			p.dna['genotype']['alluring'] = true
		elif i == 2:
			p.dna['phenotype']['long-living'] = true
			p.dna['genotype']['long-living'] = true
		
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

func new_dna(mother_gamete, father_gamete):
	var child_dna = {
		'genotype': {},
		'phenotype': {}
	}
	for trait in mother_gamete.keys():
		# true is dominant
		if mother_gamete[trait]:
			child_dna['phenotype'][trait] = mother_gamete[trait]
			child_dna['genotype'][trait] = father_gamete[trait]
		else:
			child_dna['phenotype'][trait] = father_gamete[trait]
			child_dna['genotype'][trait] = mother_gamete[trait]
			
	return child_dna

func _on_AI_copulate(player, checkpoint):
	var node_to_eliminate = []
	for n in $Content.get_children():
		if n.is_in_group("player"):
			n.remove_from_group("player")
			node_to_eliminate.append(n)
	last_checkpoint = player.position
	
	var children_amount
	if player.dna['phenotype']['fecund']:
		children_amount = 4
	else:
		children_amount = 3
	create_children(player, checkpoint, children_amount)
	
	player.queue_free()
	state_machine.set_state("selection")
	for node in node_to_eliminate:
		node.queue_free()
	
func create_children(mother, father, amount):
	for i in range(0, amount):
		var p = player.instance()
		p.position = last_checkpoint + Vector2(60, 0)*i - Vector2(30, 0)*amount
		p.dna = new_dna(mother.get_gamete(), father.get_gamete())
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