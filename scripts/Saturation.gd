extends HBoxContainer


@onready var shader : ShaderMaterial = $"..".material

func _on_slider_value_changed(value):
	shader.set_shader_parameter("saturation", value)
