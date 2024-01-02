extends Control

func _on_minus_pressed():
	if Global.octave > -3:
		Global.octave -= 1
		$Indicator.frame -= 1


func _on_plus_pressed():
	if Global.octave < 3:
		Global.octave += 1
		$Indicator.frame += 1

func _process(_delta):
	if Input.is_action_just_pressed("Minus"):
		_on_minus_pressed()
	elif Input.is_action_just_pressed("Plus"):
		_on_plus_pressed()
