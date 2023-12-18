extends VSlider

@onready var Synth = get_tree().get_root().get_node("Synth")

func _ready():
	value = Synth.note_length

func _on_drag_ended(value_changed):
	if value_changed:
		for player in Synth.get_node("AudioStreamPlayers").get_children():
			player.stream.buffer_length = value
