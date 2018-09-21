extends "platform_actor.gd"

export (String) var left = "ui_left"
export (String) var right = "ui_right"
export (String) var up = "ui_up"
export (String) var down = "ui_down"
export (String) var jump = "ui_select"
export (String) var dash = "ui_cancel"

var current_states = []
signal copulate(player, checkpoint)

var active = null

func _ready():
	set_process_input(false)
	for s in state_machine.get_children():
		current_states.append(s.name)
	
	set_state("chilling")
	
#  Questa non dovrebbe essere chiamata
func _input(event):
	state_machine.state.input_process(self, event)

func _on_change_state_timeout():
	direction = rand_range(-1,1)
	var random_choice = randi() % len(current_states)
	var random_state = current_states[random_choice]
	propagate_call(random_state)
	yield(get_tree().create_timer(0.3), "timeout")
	idle()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		active = body
		$superlove2.visible = true
		
func _process(delta):
	if active and is_instance_valid(active) and Input.is_action_just_pressed('ui_select'):
		active.set_process_input(false)
		active.set_state("chilling")
		active.remove_from_group("player")
		emit_signal("copulate", active, self)
		queue_free()


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		active = null
		$superlove2.visible = false


func _on_LoveArea_body_entered(body):
	if body.is_in_group("player"):
		$love.visible = true


func _on_LoveArea_body_exited(body):
	if body.is_in_group("player"):
		$love.visible = false


func _on_LoveTimer_timeout():
	$superlove2/love2.visible = not $superlove2/love2.visible
