extends VBoxContainer


@onready var synth: Synth = get_tree().get_root().get_node("Synth")
var noise_range = 0.05

var rflip_min_ratio = 0.05
var rflip_max_ratio = 0.15

var rflat_min_ratio = 0.02
var rflat_max_ratio = 0.05

func _on_edge_detection_pressed():
	var desired_curve : Array = synth._1D_convolution([-1,1,-1])
	desired_curve = Global.remap_to_limits(desired_curve)
	synth.start_animation(desired_curve)

func _on_noise_button_pressed():
	var desired_curve = synth.get_wave()
	for w in Global.w:
		var noise = randf_range(-Global.w * noise_range, Global.w * noise_range)
		desired_curve[w] += noise
	desired_curve = Global.remap_to_limits(desired_curve)
	synth.start_animation(desired_curve)


func _on_r_flip_button_pressed():
	var desired_curve = synth.get_wave()
	var flipping = true
	var rflip_min_size = int(rflip_min_ratio*Global.w)
	var rflip_max_size = int(rflip_max_ratio*Global.w)
	var span_size = randi_range(rflip_min_size, rflip_max_size)
	for w in Global.w:
		if flipping:
			desired_curve[w] = Global.h - desired_curve[w]
		span_size -= 1
		if span_size <= 0:
			span_size = randi_range(rflip_min_size, rflip_max_size)
			flipping = not flipping
	desired_curve = Global.remap_to_limits(desired_curve)
	synth.start_animation(desired_curve)


func _on_r_flat_button_pressed():
	var desired_curve = synth.get_wave()
	var flattening = false
	var rflip_min_size = int(rflat_min_ratio*Global.w)
	var rflip_max_size = int(rflat_max_ratio*Global.w)
	var span_size = randi_range(rflip_min_size, rflip_max_size)
	var saved_y = 0
	for w in Global.w:
		if flattening:
			desired_curve[w] = saved_y
		span_size -= 1
		if span_size <= 0:
			span_size = randi_range(rflip_min_size, rflip_max_size)
			flattening = not flattening
			if flattening:
				saved_y = desired_curve[w]
	desired_curve = Global.remap_to_limits(desired_curve)
	synth.start_animation(desired_curve)

func _keep_only(side:Array):
	var desired_curve : Array = []
	for v in side:
		desired_curve.append(v)
		desired_curve.append(v)
	desired_curve = Global.remap_to_min_max(desired_curve)
	synth.start_animation(desired_curve)

func _on_l_pressed():
	var curr_curve = synth.get_wave()
	var l_side = []
	for w in Global.w/2:
		l_side.append(curr_curve[w])
	_keep_only(l_side)


func _on_r_pressed():
	var curr_curve = synth.get_wave()
	var r_side = []
	for w in Global.w/2:
		r_side.append(curr_curve[Global.w/2+w])
	_keep_only(r_side)
