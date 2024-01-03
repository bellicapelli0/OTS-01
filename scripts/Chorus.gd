extends Control

var cho : AudioEffectChorus

var bus_i = 0
var cho_i = 3


func _ready():
	cho = AudioServer.get_bus_effect(bus_i, cho_i)
	_on_voices_value_changed(0)
	


func _on_voices_value_changed(value):
	if value == 0:
		$Light.frame = 1
		AudioServer.set_bus_effect_enabled(bus_i, cho_i, false)
	else:
		$Light.frame = 0
		AudioServer.set_bus_effect_enabled(bus_i, cho_i, true)
		cho.voice_count = value
