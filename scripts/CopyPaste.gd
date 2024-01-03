extends HBoxContainer

@onready var synth : Synth = get_tree().get_root().get_node("Synth")
@onready var info = $"../../Info"

func _on_copy_pressed():
	var wave = synth.get_wave()
	DisplayServer.clipboard_set(str(wave))
	info.text = "> Copied Successfully"
	


func _on_paste_pressed():
	var wave = JSON.parse_string(DisplayServer.clipboard_get())
	if not wave:
		info.text = "> Parse Error"
		return
	if len(wave) != Global.w:
		info.text = "> Wrong Wave length"
		return
	if wave.min() < 0:
		info.text = "> Error (low values)"
		return
	if wave.max() > Global.h:
		info.text = "> Error (high values)"
		return
	info.text = "> Pasted Successfully"
	synth.start_animation(wave)
