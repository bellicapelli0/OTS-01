extends VBoxContainer

@onready var players = $"../../../AudioStreamPlayers"
@onready var mid = $Slider.min_value + ($Slider.max_value-$Slider.min_value)/2.0
@onready var speed = 2


func _process(delta):
	$Slider.value = lerp($Slider.value, mid, speed*delta)
	for player in players.get_children():
		player.pitch_scale = $Slider.value


func _on_slider_value_changed(value):
	$Timer.start()
