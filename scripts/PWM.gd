extends HSlider

@onready var synth : Synth = get_tree().get_root().get_node("Synth")
var animating = false
var anim_speed = 1.0

func _process(delta):
	if animating:
		var v = value + sign(0.5 - value) * anim_speed * delta
		if v > 0.48 and v < 0.52:
			value = 0.5
			animating = false
			return
		set_value_no_signal(v)

func _on_button_pressed():
	$"../Button".disabled = true
	var curr_wave = synth.get_wave()
	var cutoff = int(value*Global.w)
	
	var desired_curve = []
	
	for i in range(cutoff):
		var idx = int((Global.w/2)*i/cutoff)
		var val = curr_wave[idx]
		desired_curve.append(val)
		
	for i in range(cutoff, Global.w):
		var idx = int((Global.w/2)+((Global.w/2)*(i-cutoff)/(Global.w-cutoff)))-2
		var val = curr_wave[idx]
		desired_curve.append(val)
		
	synth.start_animation(desired_curve)
	animating = true


func _on_value_changed(value):
	if value == 0.5:
		$"../Button".disabled = true
	else:
		$"../Button".disabled = false
		
