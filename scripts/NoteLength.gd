extends Control

@onready var synth : Synth = get_tree().get_root().get_node("Synth")
@onready var audio_stream_players = $"../../../AudioStreamPlayers"
@onready var slider :Slider = $Slider

func _ready():
	slider.value = synth.note_length

func _on_value_changed(val):
	for player in audio_stream_players.get_children():
		player.stream.buffer_length = val


func _on_slider_value_changed(value):
	pass # Replace with function body.
