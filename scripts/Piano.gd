extends Control

var Synth

func _ready():
	Synth = get_tree().get_root().get_node("Synth")
	pass


func _process(delta):
	pass
	

func play_note(idx):
	idx += Global.octave * 12
	if idx >= 12 and idx <= 118:
		var f = PianoKeys.get_note(idx)["frequency"]
		Synth.sound_wave(f)

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
