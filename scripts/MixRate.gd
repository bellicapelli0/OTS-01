extends OptionButton

@onready var audio_stream_players = $"../../../AudioStreamPlayers"

var values = {
	0: 16000,
	1: 22050,
	2: 32000,
	3: 44100
}

func _ready():
	_on_item_selected(selected)


func _on_item_selected(index):
	for player in audio_stream_players.get_children():
		player.stream.mix_rate = values[index]

