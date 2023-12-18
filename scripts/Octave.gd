extends Control

func _on_minus_pressed():
	if Global.octave > -2:
		Global.octave -= 1
		$Indicator.frame -= 1


func _on_plus_pressed():
	if Global.octave < 2:
		Global.octave += 1
		$Indicator.frame += 1
