extends Control

@onready var synth : Synth = get_tree().get_root().get_node("Synth")
var unscrew_chance = 0.15

func play_note(idx):
	idx += Global.octave * 12
	if idx >= 12 and idx <= 118:
		var f = PianoKeys.get_note(idx)["frequency"]
		sound_wave(f)

func sound_wave(pulse_hz):
	var player = synth.get_player()
	if not player:
		print_debug("No available players")
	player.play()
	var playback = player.get_stream_playback()
	var phase = 0.0
	var increment = pulse_hz / synth.sample_hz
	var frames_available = playback.get_frames_available()
	var fade_out = 1.0
	
	for i in range(frames_available):
		if i > frames_available * (1-0.5):
			fade_out *= 0.999
		var value = synth.line.points[int(phase*Global.w)].y
		value = remap(value, Global.h, 0, -0.5, 0.5)
		playback.push_frame(Vector2.ONE * value * fade_out) # TODO Here fadeout
		phase = fmod(phase + increment, 1.0)
	
	
func _input(input_event):
	if input_event is InputEventMIDI:
		if input_event.message == 9:
			play_note(input_event.pitch)

func _maybe_unscrew():
	if randf() <= unscrew_chance and not $"../Frame/Screws/AnimationPlayer".is_playing():
		$"../Frame/Screws".unscrew_random()

func _on_c_button_down():
	play_note(48)
	_maybe_unscrew()
func _on_c_sharp_button_down():
	play_note(49)
	_maybe_unscrew()
func _on_d_button_down():
	play_note(50)
	_maybe_unscrew()
func _on_d_sharp_button_down():
	play_note(51)
	_maybe_unscrew()
func _on_e_button_down():
	play_note(52)
	_maybe_unscrew()
func _on_f_button_down():
	play_note(53)
	_maybe_unscrew()
func _on_f_sharp_button_down():
	play_note(54)
	_maybe_unscrew()
func _on_g_button_down():
	play_note(55)
	_maybe_unscrew()
func _on_g_sharp_button_down():
	play_note(56)
	_maybe_unscrew()
func _on_a_button_down():
	play_note(57)
	_maybe_unscrew()
func _on_a_sharp_button_down():
	play_note(58)
	_maybe_unscrew()
func _on_b_button_down():
	play_note(59)
	_maybe_unscrew()
func _on_cup_button_down():
	play_note(60)
	_maybe_unscrew()
func _on_cup_sharp_button_down():
	play_note(61)
	_maybe_unscrew()
func _on_dup_button_down():
	play_note(62)
	_maybe_unscrew()
func _on_dup_sharp_button_down():
	play_note(63)
	_maybe_unscrew()
func _on_eup_button_down():
	play_note(64)
	_maybe_unscrew()
