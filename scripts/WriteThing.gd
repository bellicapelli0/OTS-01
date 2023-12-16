extends Node2D


@export var width = 300
@export var height = 100
var padding = 10

var playback
@onready var sample_hz = $AudioStreamPlayer.stream.mix_rate

var last_mouse_pos
var animating = false
var desired_curve
var percentage = 0.0
var prev_percentage
var animation_speed = 0.75

func _ready():
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	
	$Line2D.clear_points()
	$Line2D.position = Vector2(0, 0)
	for x in width:
		$Line2D.add_point(Vector2(x, height))
	$ColorRect.size = Vector2(width+padding*2, height+padding*2)
	$ColorRect.position = Vector2(-padding, -padding)
	$AnimationProgress.points[0] = Vector2(0, -padding)
	$AnimationProgress.points[1] = Vector2(0, height+padding)
	$AnimationProgress.position  = Vector2(0, 0)

func _process(delta):
	if Input.is_action_pressed("LMB"):
		var mouse_pos = get_local_mouse_position()
		mouse_pos.y = clamp(mouse_pos.y, 0, height)
		
		if mouse_pos.x >= 0 and mouse_pos.x < width:
			$Line2D.points[mouse_pos.x] = mouse_pos
		
		
		if last_mouse_pos:
			var start
			var finish
			if last_mouse_pos.x < mouse_pos.x:
				start = last_mouse_pos
				finish = mouse_pos
			else:
				start = mouse_pos
				finish = last_mouse_pos
			
			start.x = clamp(start.x, 0, width)
			finish.x = clamp(finish.x, 0, width)
			
			for x in range(start.x, finish.x):
				var weight = (x-start.x)/(finish.x-start.x)
				
				$Line2D.points[x].y = lerp(start.y, finish.y, weight)
		last_mouse_pos = mouse_pos
	else:
		last_mouse_pos = null
	
	if animating:
		prev_percentage = percentage
		percentage+=delta*animation_speed
		for i in range(int(prev_percentage*width), int(percentage*width)):
			if i>= width:
				animating = false
				$AnimationProgress.hide()
				break
			
			$Line2D.points[i].y = desired_curve[i]
			$AnimationProgress.position.x = i

func sound_wave(pulse_hz=440.0):
	$AudioStreamPlayer.play()
	playback = $AudioStreamPlayer.get_stream_playback()
	var phase = 0.0
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()
	for i in range(frames_available):
		var value = $Line2D.points[int(phase*width)].y
		value = remap(value, height, 0, 0.0, 1.0)
		playback.push_frame(Vector2.ONE * value)
		phase = fmod(phase + increment, 1.0)

func _1D_convolution(kernel=[1, 7, 30, 74, 99, 74, 30, 7, 1]):
	assert(len(kernel)%2==1)
	var output = []
	var half_kernel = (len(kernel)-1)/2
	var kernel_sum = 0
	for k in kernel:
		kernel_sum += k
	
	for i in range(width):
		var temp_sum = 0.0
		for j in range(len(kernel)):
			var index = i-half_kernel+j
			var input_value = height/2.0
			
			if index >= 0 and index<width:
				input_value = $Line2D.points[index].y
			
			temp_sum += input_value * kernel[j]
		output.append((temp_sum/kernel_sum))
	return output





func _on_a_pressed():
	sound_wave(440.0)

func _on_b_pressed():
	sound_wave(493.8833)

func _on_c_pressed():
#	sound_wave(523.2511)
	desired_curve = _1D_convolution()
	start_animation()

func preset_saw():
	desired_curve = []
	for i in width:
		desired_curve.append(height*(float(i)/width))
	start_animation()

func preset_sqr():
	desired_curve = []
	for i in width:
		desired_curve.append(0 if i<width/2 else height)
	start_animation()

func preset_sin():
	desired_curve = []
	for i in width:
		desired_curve.append((height/2)-(height/2)*sin(float(i)*TAU/width))
	start_animation()

func preset_tri():
	desired_curve = []
	for i in width:
		if i<= width/4:
			desired_curve.append((height/2)-(height/2)*float(i)/(width/4))
		elif i <= width*3/4:
			desired_curve.append(height*float(i-width/4)/(width/2))
		else:
			desired_curve.append((height)-(height/2)*float(i-width*3/4)/(width/4))
	start_animation()

func start_animation():
	prev_percentage = null
	percentage = 0.0
	animating = true
	$AnimationProgress.show()

func _input(input_event):
	if input_event is InputEventMIDI:
		pass
		_print_midi_info(input_event)

func _print_midi_info(midi_event: InputEventMIDI):
	if midi_event.message == 8:
		var note = PianoKeys.get_note(midi_event.pitch)
		print(note)
		sound_wave(note["frequency"])
#	print(midi_event)



func _on_saw_pressed():
	preset_sin()
