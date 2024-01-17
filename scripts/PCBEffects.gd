extends Control


var lofi : AudioEffectDistortion

var bus_i = 0
var lofi_i = 5

var rev_value : float
var chr_value : float
var del_value : float
var danger_score = 0
@export var danger_threshold = 100

@onready var lofi_slider : Slider = $HBoxContainer/Lofi/LofiSlider
@onready var lofi_button : TextureButton = $HBoxContainer/Lofi/LofiButton


func _ready():
	lofi = AudioServer.get_bus_effect(bus_i, lofi_i)

	_on_lofi_slider_value_changed(lofi_slider.value)


func _on_lofi_button_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, lofi_i,  lofi_button.button_pressed)

func _on_lofi_slider_value_changed(value):
	if value == lofi_slider.min_value:
		lofi_button.button_pressed = false
		AudioServer.set_bus_effect_enabled(bus_i, lofi_i, false)
	elif not lofi_button.button_pressed:
		lofi_button.button_pressed = true
		AudioServer.set_bus_effect_enabled(bus_i,lofi_i, true)
	lofi.drive = value


	
