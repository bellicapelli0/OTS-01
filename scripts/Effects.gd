extends Control


var del : AudioEffectDelay
var rev : AudioEffectReverb

var bus_i = 0
var del_i = 2
var rev_i = 3


func _ready():
	del = AudioServer.get_bus_effect(bus_i, del_i)
	rev = AudioServer.get_bus_effect(bus_i, rev_i)
	
	_on_del_slider_value_changed($HBoxContainer/Delay/DelSlider.value)
	_on_rev_slider_value_changed($HBoxContainer/Reverb/RevSlider.value)


func _on_del_button_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, del_i, $HBoxContainer/Delay/DelButton.button_pressed)


func _on_rev_button_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, rev_i, $HBoxContainer/Reverb/RevButton.button_pressed)


func _on_del_slider_value_changed(value):
	del.tap1_level_db = value
	del.tap2_level_db = value * 2


func _on_rev_slider_value_changed(value):
	rev.wet = remap(value,
	$HBoxContainer/Reverb/RevSlider.min_value,
	$HBoxContainer/Reverb/RevSlider.max_value,
	0.1,
	0.5)
