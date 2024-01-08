extends VBoxContainer

@onready var players = $"../../../AudioStreamPlayers"
@onready var mid = $Slider.min_value + ($Slider.max_value-$Slider.min_value)/2.0
@onready var speed = 2


func _process(delta):
	for player in players.get_children():
		player.pitch_scale = $Slider.value
	if not Input.is_action_pressed("LMB"):
		$Slider.value = lerp($Slider.value, mid, speed*delta)
	


