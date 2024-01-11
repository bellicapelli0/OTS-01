extends Control

@onready var synth : Synth = get_tree().get_root().get_node("Synth")
@onready var frq_slider : Slider= $VBoxContainer/Sliders/Frequency
@onready var dpt_slider : Slider= $VBoxContainer/Sliders/Depth
@onready var osc_slider : Slider= $VBoxContainer/Sliders/Oscillator


func _on_button_pressed():
	var frequency = frq_slider.value
	var length = Global.w / frequency
	var depth = dpt_slider.value
	var oscillator = osc_slider.value
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
	
	desired_curve = Global.remap_to_limits(desired_curve)
	
	synth.start_animation(desired_curve)

###
# Presets

func _sin(length, depth):
	var curve = []
	for i in length:
		curve.append(-sin(i*TAU/length)*Global.h*depth)
	return curve

func _sqr(length, depth):
	var curve = []
	for i in length:
		if i < length/2:
			curve.append(-Global.h*depth)
		else:
			curve.append(Global.h*depth)
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
