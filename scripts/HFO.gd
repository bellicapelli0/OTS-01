extends Control

@onready var synth : Synth = get_tree().get_root().get_node("Synth")

func _on_button_pressed():
	var frequency = $VBoxContainer/Sliders/Frequency.value
	var length = Global.w / frequency
	var depth = $VBoxContainer/Sliders/Depth.value
	var oscillator = $VBoxContainer/Sliders/Oscillator.value
	var curve = []
	if oscillator == 4:
		curve = _sin(length, depth)
	if oscillator == 3:
		curve = _sqr(length, depth)
	if oscillator == 2:
		curve = _tri(length, depth)
	if oscillator == 1:
		curve = _saw(length, depth)
	
	var desired_curve = synth.get_wave()

	
	for i in frequency:
		for j in length:
			desired_curve[length*i + j] += curve[j]
	
	var mmin = desired_curve.min()
	var mmax = desired_curve.max()
	if mmin < 0 or mmax > Global.h:
		for x in Global.w:
			desired_curve[x] = remap(desired_curve[x], mmin, mmax, max(0, mmin), min(Global.h, mmax))
	
	synth.start_animation(desired_curve)

func _sin(length, depth):
	var curve = []
	for i in length:
		curve.append(-sin(i*TAU/length)*Global.h*depth)
	return curve

func _sqr(length, depth):
	var curve = []
	for i in length:
		if i < length/2:
			curve.append(Global.h*depth)
		else:
			curve.append(-Global.h*depth)
	return curve

func _tri(length, depth):
	depth *= 2
	var curve = []
	var l2 = length/2
	for i in length:
		if i <= l2:
			curve.append(Global.h*depth/2-(((length-i)/l2)-1)*Global.h*depth)
		else:
			curve.append(Global.h*depth/2+(((length-i)/l2)-1)*Global.h*depth)
	return curve

func _saw(length, depth):
	var curve = []
	var l2 = length/2
	for i in length:
		curve.append(-(((length-i)/l2)-1)*Global.h*depth)
		
	return curve
