extends HSlider

@onready var synth : Synth = get_tree().get_root().get_node("Synth")

func _ready():
	value = synth.note_length

func _on_value_changed(val):
	for player in synth.get_node("AudioStreamPlayers").get_children():
		player.stream.buffer_length = val
