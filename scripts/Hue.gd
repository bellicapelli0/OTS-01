extends HBoxContainer

@onready var shader : ShaderMaterial = $"../../Frame".material

func _ready():
	shader.set_shader_parameter("hue", 0.0)



func _on_h_slider_value_changed(value):
	shader.set_shader_parameter("hue", value)
