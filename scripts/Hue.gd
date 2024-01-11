extends HBoxContainer

@onready var shader : ShaderMaterial = $"..".material
@onready var sat_slider = $"../Saturation/Slider"
@onready var anim_speed_slider : Slider = $"../AnimationSpeed/Slider"
@onready var hue_slider : Slider = $HSlider

var _animating = false
var _anim_speed = 0.15
var _sat_anim_speed = 0.08

var saturation_value = 0.0
var saturation_range = 0.2

func _ready():
	shader.set_shader_parameter("hue", 0.0)

func _process(delta):
	if _animating:
		var anim_multiplier = delta * _anim_speed * anim_speed_slider.value
		hue_slider.value = clamp(hue_slider.value + anim_multiplier, 0.0, 1.0)
		if hue_slider.value == 0.0 or hue_slider.value == 1.0:
			_anim_speed = -_anim_speed
			
		var sat_anim_multiplier = delta * _sat_anim_speed * anim_speed_slider.value
		sat_slider.value = clamp(sat_slider.value + sat_anim_multiplier, 0.0, 1.0)
		
		saturation_value = clamp(saturation_value + sat_anim_multiplier, -saturation_range, saturation_range)		
		if saturation_value <= -saturation_range or saturation_value >= saturation_range:
			_sat_anim_speed = -_sat_anim_speed
		elif sat_slider.value <= 0.0 or sat_slider.value >= 1.0:
			_sat_anim_speed = -_sat_anim_speed
			
		
func _on_h_slider_value_changed(value):
	shader.set_shader_parameter("hue", value)

func _on_gay_toggled(toggled_on):
	_animating = toggled_on



