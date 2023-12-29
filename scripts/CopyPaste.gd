extends HBoxContainer

@onready var synth : Synth = get_tree().get_root().get_node("Synth")
@onready var info = $"../Info"

func _on_copy_pressed():
	var wave = synth.get_wave()
	DisplayServer.clipboard_set(str(wave))
	info.text = "Copied Successfully"
	


func _on_paste_pressed():
	var wave = JSON.parse_string(DisplayServer.clipboard_get())
	if not wave:
		info.text = "Wave could not be parsed"
		return
	if len(wave) != Global.w:
		info.text = "Incorrect Wave length"
		return
	if wave.min() < 0:
		info.text = "Wrong value(s) (too low)"
		return
	if wave.max() > Global.h:
		info.text = "Wrong value(s) (too high)"
		return
	info.text = "Pasted Successfully"
	synth.start_animation(wave)
