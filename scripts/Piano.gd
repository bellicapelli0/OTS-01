extends Control

@onready var synth : Synth = get_tree().get_root().get_node("Synth")


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
	
	for i in range(frames_available):
		if i > frames_available * (1-0.15):
			fade_out *= 0.99
		var value = synth.line.points[int(phase*Global.w)].y
		value = remap(value, Global.h, 0, -0.5, 0.5)
		playback.push_frame(Vector2.ONE * value * 1.0) # TODO Here fadeout
		phase = fmod(phase + increment, 1.0)
	



func _on_c_button_down():
	play_note(48)
func _on_c_sharp_button_down():
	play_note(49)
func _on_d_button_down():
	play_note(50)
func _on_d_sharp_button_down():
	play_note(51)
func _on_e_button_down():
	play_note(52)
func _on_f_button_down():
	play_note(53)
func _on_f_sharp_button_down():
	play_note(54)
func _on_g_button_down():
	play_note(55)
func _on_g_sharp_button_down():
	play_note(56)
func _on_a_button_down():
	play_note(57)
func _on_a_sharp_button_down():
	play_note(58)
func _on_b_button_down():
	play_note(59)
func _on_cup_button_down():
	play_note(60)
func _on_cup_sharp_button_down():
	play_note(61)
func _on_dup_button_down():
	play_note(62)
func _on_dup_sharp_button_down():
	play_note(63)
func _on_eup_button_down():
	play_note(64)
