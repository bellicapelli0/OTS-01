extends TextureRect

@export var screw_name : String
var i = 0
signal unscrewed

func _on_texture_button_pressed():
	texture.region.position.x += 26
	$TextureButton.position.y -= 4
	$TextureButton.size.y += 4
	i+=1
	if i == 6:
		$TextureButton.disabled = true
		emit_signal("unscrewed")
