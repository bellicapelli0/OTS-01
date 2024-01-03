extends Control
class_name Synth

@export var width = 400
@export var height = 135
var padding = 8

var last_mouse_pos
var animating = false
var desired_curve
var percentage = 0.0
var prev_percentage
var animation_speed = 0.75
var _undo = false

@export var sample_hz = 44100
var player_index = 0
@onready var n_players = len($AudioStreamPlayers.get_children())
@export var note_length = 0.5

@onready var line : Line2D = $Wave/Line2D
@onready var amp : VSlider = $Frame/Amp
@onready var undo : TextureButton = $Frame/Buttons/Undo

func _ready():
	Global.w = width
	Global.h = height
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	
	line.clear_points()
	line.position = Vector2(0, 0)
	
	var weir = $Frame/Presets.weir
	
	for x in width:
		line.add_point(Vector2(x, weir[x]))
		
	$Wave/BG.size = Vector2(width+padding*2, height+padding*2)
	$Wave/BG.position = Vector2(-padding, -padding)
	$Wave/AnimationProgress.points[0] = Vector2(0, -padding)
	$Wave/AnimationProgress.points[1] = Vector2(0, height+padding)
	$Wave/AnimationProgress.position  = Vector2(0, 0)
	$"Wave/0Line".points[0] = Vector2(0, height/2.0)
	$"Wave/0Line".points[1] = Vector2(width, height/2.0)
	
	$Frame.show()
	
func _process(delta):
#region animation
	if animating:
		prev_percentage = percentage
		if _undo:
			percentage-=delta*animation_speed
			for i in range(int(percentage*width),int(prev_percentage*width)):
				if i< 0:
					_undo = false
					animating = false
					$Wave/AnimationProgress.hide()
					break
				
				line.points[i].y = desired_curve[i]
				$Wave/AnimationProgress.position.x = i
		else:
			percentage+=delta*animation_speed
			for i in range(int(prev_percentage*width), int(percentage*width)):
				if i>= width:
					animating = false
					$Wave/AnimationProgress.hide()
					break
				
				line.points[i].y = desired_curve[i]
				$Wave/AnimationProgress.position.x = i
#endregion
		
#region mouse control
	if Input.is_action_just_pressed("LMB"):
		var mouse_pos = get_local_mouse_position()
		if mouse_pos.y > 0-padding and mouse_pos.y < height+padding:
			if mouse_pos.x > 0-padding and mouse_pos.x < width+padding:
				undo.save_curve(get_wave())
		
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
#endregion
	

func get_wave():
	var wave = []
	for x in width:
		wave.append(line.points[x].y)
	return wave

func get_player():
	player_index += 1
	player_index = player_index % n_players
	return $AudioStreamPlayers.get_children()[player_index]

func start_animation(curve, backwards=false):
	#if get_wave() == curve:
		#return
		
	if not backwards:
		undo.save_curve(get_wave())
	desired_curve = curve
	
	if backwards:
		if not animating or _undo:
			percentage = 1.0
		_undo = true
	else:
		percentage = 0.0
		_undo = false
		
	prev_percentage = null
	animating = true
	$Wave/AnimationProgress.show()

func stop_animation():
	_undo = false
	animating = false
	$Wave/AnimationProgress.hide()


func _1D_convolution(kernel=[1]):
	assert(len(kernel)%2==1)
	var output = []
	var half_kernel = (len(kernel)-1)/2.0
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






