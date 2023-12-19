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
		
		
func get_wave():
	var wave = []
	for x in width:
		wave.append(line.points[x].y)
	return wave

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












