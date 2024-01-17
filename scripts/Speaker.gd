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

@onready var bus_i = AudioServer.get_bus_index("Master")
var slider_vol
var spectrum_i = 6
var volume_db_min = -40
var volume_db_max = 0

func _ready():
	_on_volume_value_changed($Volume.value)
	spectrum = AudioServer.get_bus_effect_instance(bus_i, spectrum_i)

func _process(_delta):
	volume = spectrum.get_magnitude_for_frequency_range(200, 3000).length()
	slider_vol = $Volume.value / 100.0
	$Front.scale = Vector2.ONE * remap(volume, noise_min, noise_max/slider_vol, min_front_scale, max_front_scale ) 
	$Back.scale = Vector2.ONE * remap(volume, noise_min, noise_max/slider_vol, min_back_scale, max_back_scale) 


func _on_volume_value_changed(value):
	var volume_db = remap(value, 0, 100, volume_db_min, volume_db_max)
	if value <= 2:
		volume_db = -1000
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_db)

