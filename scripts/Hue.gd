extends HBoxContainer

@onready var shader : ShaderMaterial = $"../../../Frame".material
var _animating = false
var _anim_speed = 0.15

func _ready():
	shader.set_shader_parameter("hue", 0.0)

func _process(delta):
	if _animating:
		var anim_multiplier = delta * _anim_speed * $"../AnimationSpeed/Slider".value
		$HSlider.value = fmod($HSlider.value + anim_multiplier, 1.0)

func _on_h_slider_value_changed(value):
	shader.set_shader_parameter("hue", value)

func _on_gay_toggled(toggled_on):
	_animating = toggled_on
