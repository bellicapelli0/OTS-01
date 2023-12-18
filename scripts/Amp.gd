extends VSlider

@onready var synth : Synth = get_tree().get_root().get_node("Synth")

@onready var old_val = value



func _on_drag_ended(value_changed):
	if not value_changed:
		return
	var desired_curve = []

	for x in Global.w:
		desired_curve.append(synth.line.points[x].y)
	var min_val = desired_curve.min()
	var max_val = desired_curve.max()
	if min_val == max_val:
		max_val += 0.01
		min_val -= 0.01
	
	
	var out_min = (1-value) * (Global.h - min_val)
	var out_max = value * Global.h
	
	for x in Global.w:
		desired_curve[x] = remap(desired_curve[x], min_val, max_val, out_min, out_max)
		#desired_curve[x] -= Global.h/2
		#desired_curve[x] += (max_val - min_val)*2
	synth.desired_curve = desired_curve
	synth.start_animation(desired_curve)

	
