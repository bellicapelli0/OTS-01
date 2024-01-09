extends VBoxContainer

@onready var synth : Synth = get_tree().get_root().get_node("Synth")

func _ready():
	synth.animation_speed = $Slider.value

func _on_slider_value_changed(value):
	if value == $Slider.max_value:
		value *= 1000
	synth.animation_speed = value
	$"../../../Frame/AnimationPlayer".speed_scale = remap(value, 0.75, $Slider.max_value, 1, 4)
