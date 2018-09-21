extends "platform_actor.gd"

export (String) var left = "ui_left"
export (String) var right = "ui_right"
export (String) var up = "ui_up"
export (String) var down = "ui_down"
export (String) var jump = "ui_select"
export (String) var dash = "ui_cancel"

signal dead
signal collect

var life_span

func _ready():
	if dna['phenotype']['long-living']:
		life_span = 90
	else:
		life_span = 60
		
	$life_span.wait_time = life_span

func handle_input():
	pass

func _input(event):
	if event.is_action_pressed("ui_action"):
		set_state("dead")
	state_machine.state.input_process(self, event)

func _on_dead_player_dead():
	emit_signal("dead")

func _on_life_span_timeout():
	die()


func _on_collector_area_entered(area):
	print(area.get_groups())
	if area.is_in_group("collectible"):
		emit_signal("collect")
		area.queue_free()
