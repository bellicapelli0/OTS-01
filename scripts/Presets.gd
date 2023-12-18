extends HBoxContainer

@onready var synth: Synth = get_tree().get_root().get_node("Synth")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func send_preset(desired_curve):
	synth.start_animation(desired_curve)
	synth.amp.set_value_no_signal(1.0)


func preset_saw():
	var desired_curve = []
	for i in Global.w:
		desired_curve.append(Global.h*(float(i)/Global.w))
	desired_curve[0] = Global.h	
	send_preset(desired_curve)

func preset_sqr():
	var desired_curve = []
	for i in Global.w:
		desired_curve.append(0 if i<Global.w/2 else Global.h)
	send_preset(desired_curve)

func preset_sin():
	var desired_curve = []
	for i in Global.w:
		desired_curve.append((Global.h/2)-(Global.h/2)*sin(float(i)*TAU/Global.w))
	send_preset(desired_curve)

func preset_tri():
	var desired_curve = []
	for i in Global.w:
		if i<= Global.w/4:
			desired_curve.append((Global.h/2)-(Global.h/2)*float(i)/(Global.w/4))
		elif i <= Global.w*3/4:
			desired_curve.append(Global.h*float(i-Global.w/4)/(Global.w/2))
		else:
			desired_curve.append((Global.h)-(Global.h/2.0)*float(i-Global.w*3.0/4.0)/(Global.w/4.0))
	send_preset(desired_curve)
	
func preset_lin():
	var desired_curve = []
	for i in Global.w:
		desired_curve.append(Global.h/2 + randf()*0.001)
	send_preset(desired_curve)
	synth.amp.set_value_no_signal(synth.amp.min_value)
	
