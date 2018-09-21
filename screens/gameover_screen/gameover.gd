extends "res://screens/basic_screen.gd"
var touch = false
func _input(event):
	if event is InputEventKey and event.pressed and not touch:
		touch = true
		change_scene()

func _ready():
	# write here Winner condition
	pass
	
	