extends Control

@onready var synth : Synth = get_tree().get_root().get_node("Synth")

func _on_up_down_pressed():
	var wave = synth.get_wave()
	var desired_curve = []
	for x in Global.w:
		desired_curve.append(Global.h - wave[x])
	synth.start_animation(desired_curve)
		



func _on_left_right_pressed():
	var wave = synth.get_wave()
	var desired_curve = []
	for x in Global.w:
		desired_curve.append(wave[Global.w - x - 1])
	synth.start_animation(desired_curve)
