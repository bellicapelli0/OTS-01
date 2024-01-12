extends VBoxContainer

@onready var synth : Synth = get_tree().get_root().get_node("Synth")
@onready var slider : Slider = $Slider
@onready var max_texture : TextureRect = $Max
@onready var frame_animation : AnimationPlayer = $"../../../Frame/AnimationPlayer"

var max_speed_multiplier = 1000

func _ready():
	synth.animation_speed = slider.value

func _on_slider_value_changed(value):
	if value == slider.max_value:
		max_texture.texture.region.position.y = 16
		value *= max_speed_multiplier 
	else:
		max_texture.texture.region.position.y = 0
	synth.animation_speed = value
	frame_animation.speed_scale = remap(value, 0.75, slider.max_value, 1, 4)


func _on_max_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		slider.value = slider.max_value
