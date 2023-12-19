extends Control

var volume
var spectrum

var min_front_scale = 1.0
var max_front_scale = 1.5

var min_back_scale = 1.0
var max_back_scale = 0.95

var noise_min = 0.0
var noise_max = 0.4

var loud_max = 0.3

@onready var master_i = AudioServer.get_bus_index("Master")
var slider_vol

func _ready():
	AudioServer.set_bus_volume_db(master_i, remap($Volume.value, 0, 100, -40, -10))
	spectrum = AudioServer.get_bus_effect_instance(0, 0)

func _process(_delta):
	volume = spectrum.get_magnitude_for_frequency_range(0, 10000).length()
	max_vol = max(volume, max_vol)
	slider_vol = $Volume.value / 100.0
	$Front.scale = Vector2.ONE * remap(volume, noise_min, noise_max/slider_vol, min_front_scale, max_front_scale ) 
	$Back.scale = Vector2.ONE * remap(volume, noise_min, noise_max/slider_vol, min_back_scale, max_back_scale) 

func _on_volume_value_changed(value):
	var volume_db = remap(value, 0, 100, -40, -20)
	if value <= 2:
		volume_db = -1000
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)

var max_vol = 0.0
func _on_timer_timeout():
	print(max_vol)
	max_vol = 0.0
