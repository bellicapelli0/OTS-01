extends Control


@export var width = 400
@export var height = 135
var padding = 4

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
	
	$Wave/Line2D.clear_points()
	$Wave/Line2D.position = Vector2(0, 0)
	
	for x in width:
		$Wave/Line2D.add_point(Vector2(x, (height/2)-(height/2)*sin(float(x)*TAU/width)))
		
	$Wave/BG.size = Vector2(width+padding*2, height+padding*2)
	$Wave/BG.position = Vector2(-padding, -padding)
	$Wave/AnimationProgress.points[0] = Vector2(0, -padding)
	$Wave/AnimationProgress.points[1] = Vector2(0, height+padding)
	$Wave/AnimationProgress.position  = Vector2(0, 0)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), remap($Volume.value, 0, 100, -40, -4))
	
func _process(delta):
	if animating:
		prev_percentage = percentage
		percentage+=delta*animation_speed
		for i in range(int(prev_percentage*width), int(percentage*width)):
			if i>= width:
				animating = false
				$Wave/AnimationProgress.hide()
				break
			
			$Wave/Line2D.points[i].y = desired_curve[i]
			$Wave/AnimationProgress.position.x = i
			

		
	if Input.is_action_pressed("LMB"):
		var mouse_pos = get_local_mouse_position()
		if mouse_pos.y < 0-padding or mouse_pos.y > height+padding:
			last_mouse_pos = null
			return
		
		mouse_pos.y = clamp(mouse_pos.y, 0, height)
		
		if mouse_pos.x >= 0 and mouse_pos.x < width:
			$Wave/Line2D.points[mouse_pos.x] = mouse_pos
		
		
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
				
				$Wave/Line2D.points[x].y = lerp(start.y, finish.y, weight)
		last_mouse_pos = mouse_pos
	else:
		last_mouse_pos = null
	


func sound_wave(pulse_hz=440.0):
	$AudioStreamPlayer.play()
	playback = $AudioStreamPlayer.get_stream_playback()
	var phase = 0.0
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()
	for i in range(frames_available):
		var value = $Wave/Line2D.points[int(phase*width)].y
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
				input_value = $Wave/Line2D.points[index].y
			
			temp_sum += input_value * kernel[j]
		output.append((temp_sum/kernel_sum))
	return output



func preset_saw():
	desired_curve = []
	for i in width:
		desired_curve.append(height*(float(i)/width))
	desired_curve[0] = height	
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
			desired_curve.append((height)-(height/2.0)*float(i-width*3.0/4.0)/(width/4.0))
	start_animation()

func start_animation():
	prev_percentage = null
	percentage = 0.0
	animating = true
	$Wave/AnimationProgress.show()

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



func _on_sin_button_pressed():
	preset_sin()

func _on_saw_button_pressed():
	preset_saw()

func _on_sqr_button_pressed():
	preset_sqr()

func _on_tri_button_pressed():
	preset_tri()


func _on_smooth_button_pressed():
	var smoothness = int($Smoothness.value)
	var kernel = [1]
	print(smoothness)
	match smoothness:
		3:
			kernel = [0.3191677684538592, 0.36166446309228156, 0.3191677684538592]
		11:
			kernel = [0.008812229292562283, 0.027143577143479366, 0.06511405659938266, 0.12164907301380957, 0.17699835683135567, 0.2005654142388208, 0.17699835683135567, 0.12164907301380957, 0.06511405659938266, 0.027143577143479366, 0.008812229292562283]
		19:
			kernel = [7.991883346614541e-06, 6.691521999827501e-05, 0.00043634204600584767, 0.0022159277531582037, 0.008764164276189706, 0.026995526470205033, 0.06475890149700966, 0.1209855559295398, 0.17603294517029064, 0.19947145950851228, 0.17603294517029064, 0.1209855559295398, 0.06475890149700966, 0.026995526470205033, 0.008764164276189706, 0.0022159277531582037, 0.00043634204600584767, 6.691521999827501e-05, 7.991883346614541e-06]
		27:
			kernel = [1.3347783073939505e-10, 3.0379414249401485e-09, 5.3848800213221655e-08, 7.433597573741239e-07, 7.991870553527727e-06, 6.691511288307056e-05, 0.00043634134752697435, 0.002215924205989796, 0.008764150246866505, 0.026995483256847336, 0.06475879783355351, 0.12098536226070691, 0.1760326633838015, 0.19947114020258802, 0.1760326633838015, 0.12098536226070691, 0.06475879783355351, 0.026995483256847336, 0.008764150246866505, 0.002215924205989796, 0.00043634134752697435, 6.691511288307056e-05, 7.991870553527727e-06, 7.433597573741239e-07, 5.3848800213221655e-08, 3.0379414249401485e-09, 1.3347783073939505e-10]
			
	desired_curve = _1D_convolution(kernel)
	start_animation()


func _on_volume_value_changed(value):
	var volume_db = remap(value, 0, 100, -40, -4)
	if value <= 2:
		volume_db = -1000
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)
