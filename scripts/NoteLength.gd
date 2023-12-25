extends HSlider

@onready var synth : Synth = get_tree().get_root().get_node("Synth")

func _ready():
	value = synth.note_length
	_on_value_changed(value)

func _on_value_changed(value):
	for player in synth.get_node("AudioStreamPlayers").get_children():
		player.stream.buffer_length = value
