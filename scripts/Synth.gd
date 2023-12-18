extends Control
class_name Synth

@export var width = 400
@export var height = 135
var padding = 4

var last_mouse_pos
var animating = false
var desired_curve
var percentage = 0.0
var prev_percentage
var animation_speed = 0.75

@export var sample_hz = 44100
var player_index = 0
@onready var n_players = len($AudioStreamPlayers.get_children())
var note_length = 0.5

@onready var line : Line2D = $Wave/Line2D
@onready var amp : VSlider = $Frame/Amp

func _ready():
	Global.w = width
	Global.h = height
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	
	line.clear_points()
	line.position = Vector2(0, 0)
	
	for x in width:
		line.add_point(Vector2(x, (height/2)-(height/2)*sin(float(x)*TAU/width)))
		
	$Wave/BG.size = Vector2(width+padding*2, height+padding*2)
	$Wave/BG.position = Vector2(-padding, -padding)
	$Wave/AnimationProgress.points[0] = Vector2(0, -padding)
	$Wave/AnimationProgress.points[1] = Vector2(0, height+padding)
	$Wave/AnimationProgress.position  = Vector2(0, 0)
	$"Wave/0Line".points[0] = Vector2(0, height/2)
	$"Wave/0Line".points[1] = Vector2(width, height/2)
	
	
	for player in $AudioStreamPlayers.get_children():
		player.stream.mix_rate = sample_hz
		player.stream.buffer_length = note_length
	
	
func _process(delta):
	if animating:
		prev_percentage = percentage
		percentage+=delta*animation_speed
		for i in range(int(prev_percentage*width), int(percentage*width)):
			if i>= width:
				animating = false
				$Wave/AnimationProgress.hide()
				break
			
			line.points[i].y = desired_curve[i]
			$Wave/AnimationProgress.position.x = i
			

		
	if Input.is_action_pressed("LMB"):
		var mouse_pos = get_local_mouse_position()
		if mouse_pos.y < 0-padding or mouse_pos.y > height+padding:
			last_mouse_pos = null
			return
		
		mouse_pos.y = clamp(mouse_pos.y, 0, height)
		
		if mouse_pos.x >= 0 and mouse_pos.x < width:
			line.points[mouse_pos.x] = mouse_pos
		
		
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
				
				line.points[x].y = lerp(start.y, finish.y, weight)
		last_mouse_pos = mouse_pos
	else:
		last_mouse_pos = null
	
var fade_out = 0.1

func sound_wave(pulse_hz=440.0):
	var player = get_player()
	if not player:
		print_debug("No available players")
	player.play()
	var playback = player.get_stream_playback()
	var phase = 0.0
	var increment = pulse_hz / sample_hz
	var frames_available = playback.get_frames_available()
	var fade_out = 1.0
	for i in range(frames_available):
		if i > frames_available * (1-0.15):
			fade_out *= 0.99
		var value = line.points[int(phase*width)].y
		value = remap(value, height, 0, -0.5, 0.5)
		playback.push_frame(Vector2.ONE * value * fade_out)
		phase = fmod(phase + increment, 1.0)
		
		
func get_player():
	player_index += 1
	player_index = player_index % n_players
	return $AudioStreamPlayers.get_children()[player_index]


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
				input_value = line.points[index].y
			
			temp_sum += input_value * kernel[j]
		output.append((temp_sum/kernel_sum))
	return output




func start_animation(curve):
	desired_curve = curve
	prev_percentage = null
	percentage = 0.0
	animating = true
	$Wave/AnimationProgress.show()

func _input(input_event):
	if input_event is InputEventMIDI:
		if input_event.message == 8:
			var note = PianoKeys.get_note(input_event.pitch)
			print(note)
			sound_wave(note["frequency"])



func _on_smooth_button_pressed():
	var smoothness = int($Frame/Smoothness.value)
	var kernel = [1]
	match smoothness:
		3:
			kernel = [0.3191677684538592, 0.36166446309228156, 0.3191677684538592]
		11:
			kernel = [0.008812229292562283, 0.027143577143479366, 0.06511405659938266, 0.12164907301380957, 0.17699835683135567, 0.2005654142388208, 0.17699835683135567, 0.12164907301380957, 0.06511405659938266, 0.027143577143479366, 0.008812229292562283]
		19:
			kernel = [7.991883346614541e-06, 6.691521999827501e-05, 0.00043634204600584767, 0.0022159277531582037, 0.008764164276189706, 0.026995526470205033, 0.06475890149700966, 0.1209855559295398, 0.17603294517029064, 0.19947145950851228, 0.17603294517029064, 0.1209855559295398, 0.06475890149700966, 0.026995526470205033, 0.008764164276189706, 0.0022159277531582037, 0.00043634204600584767, 6.691521999827501e-05, 7.991883346614541e-06]
		27:
			kernel = [1.3347783073939505e-10, 3.0379414249401485e-09, 5.3848800213221655e-08, 7.433597573741239e-07, 7.991870553527727e-06, 6.691511288307056e-05, 0.00043634134752697435, 0.002215924205989796, 0.008764150246866505, 0.026995483256847336, 0.06475879783355351, 0.12098536226070691, 0.1760326633838015, 0.19947114020258802, 0.1760326633838015, 0.12098536226070691, 0.06475879783355351, 0.026995483256847336, 0.008764150246866505, 0.002215924205989796, 0.00043634134752697435, 6.691511288307056e-05, 7.991870553527727e-06, 7.433597573741239e-07, 5.3848800213221655e-08, 3.0379414249401485e-09, 1.3347783073939505e-10]
			
	
	start_animation(_1D_convolution(kernel))








