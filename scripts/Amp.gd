extends VSlider

@onready var synth : Synth = get_tree().get_root().get_node("Synth")

func _on_drag_ended(_value_changed):
	var desired_curve = synth.get_wave()
	var min_val = desired_curve.min()
	var max_val = desired_curve.max()
	if min_val == max_val:
		max_val += 0.01
		min_val -= 0.01
	
	
	var out_min = (1-value) * Global.h
	var out_max = value * Global.h
	
	for x in Global.w:
		desired_curve[x] = remap(desired_curve[x], min_val, max_val, out_min, out_max)

	synth.desired_curve = desired_curve
	synth.start_animation(desired_curve)

	

