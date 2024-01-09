extends ColorRect

@onready var line : Line2D = $Line2D
var points = 10
var pad = 5
var x0 = size.x - pad

var bus_i = 0
var spectrum_i = 5
var spectrum = AudioServer.get_bus_effect_instance(bus_i, spectrum_i)

var volume
var multiplier = 1
var min_freq = 100
var max_freq = 10000
var noise_min = 0.0
var noise_max = 0.05
var speed = 0.9

var mid = size.y / 2
var Y = mid

var obj = pad

func _ready():
	line.add_point(Vector2(0, 0))
	line.add_point(Vector2(size.x, 0))


func _process(delta):
	volume = spectrum.get_magnitude_for_frequency_range(min_freq, max_freq).length()
	var vol_y = remap(volume, noise_min, noise_max, size.y-pad, pad)
	

	line.position.y = move_toward(line.position.y , vol_y, (speed*$"..".selected+1.1)*$"../../Pitch/SliderContainer/Slider".value)
	line.position.y = clamp(line.position.y, pad, size.y-pad)
	
