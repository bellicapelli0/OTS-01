extends Control

@onready var players = $"../../../AudioStreamPlayers"
@onready var slider = $Slider
@onready var anim_speed = $"../AnimationSpeed/Slider"
@onready var mid = slider.min_value + (slider.max_value-slider.min_value)/2.0
@onready var speed = 2
@onready var up_wheel = $Up
@onready var down_wheel = $Down



func _process(delta):
	
		
	up_wheel.size.y = remap(slider.value, slider.min_value, slider.max_value, 108, 2)
	
	down_wheel.size.y = remap(slider.value, slider.min_value, slider.max_value, 2, 108)
	down_wheel.position.y = remap(slider.value, slider.min_value, slider.max_value, 136, 30)
	
	for player in players.get_children():
		player.pitch_scale = slider.value
	



	if not Input.is_action_pressed("LMB"): 
		slider.value = lerp(slider.value, mid, speed*delta*anim_speed.value)


