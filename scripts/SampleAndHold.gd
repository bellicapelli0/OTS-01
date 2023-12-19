extends HSlider

@onready var synth : Synth = get_tree().get_root().get_node("Synth")


func _on_button_pressed():
	var length = int(Global.w / value)
	var desired_curve = synth.get_wave()
	var sample = desired_curve[0]
	for x in Global.w:
		if x % length == 0:
			sample = desired_curve[x]
		desired_curve[x] = sample
	synth.start_animation(desired_curve)
