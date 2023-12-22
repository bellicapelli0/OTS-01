extends TextureButton

@onready var synth : Synth = get_tree().get_root().get_node("Synth")

func _ready():
	disabled = true


func _process(_delta):
	disabled = not synth.animating




func _on_pressed():
	synth.stop_animation()
