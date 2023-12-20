extends TextureButton

@onready var synth : Synth = get_tree().get_root().get_node("Synth")
var saved_curves : Array = []
var max_saved_curves = 5

func _ready():
	disabled = true

func disable():
	disabled = true
	
func save_curve(curve):
	if disabled:
		disabled = false
	saved_curves.append(curve)
	if len(saved_curves) > max_saved_curves:
		saved_curves.pop_front()

func _on_pressed():
	synth.start_animation(saved_curves.pop_back(), true)
	if len(saved_curves) == 0:
		disable()
