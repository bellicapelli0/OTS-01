extends Control

@onready var players = $"../../../AudioStreamPlayers"
@onready var slider = $SliderContainer/Slider
@onready var mid = slider.min_value + (slider.max_value-slider.min_value)/2.0
@onready var speed = 2

func _process(delta):
	for player in players.get_children():
		player.pitch_scale = slider.value
	if not Input.is_action_pressed("LMB"):
		slider.value = lerp(slider.value, mid, speed*delta)
	


