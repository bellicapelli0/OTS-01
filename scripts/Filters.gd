extends Control

var lpf : AudioEffectLowPassFilter
var hpf : AudioEffectHighPassFilter

var bus_i = 0
var lpf_i = 0
var hpf_i = 1

@onready var cut_slider : Slider = $VBoxContainer/Sliders/Cutoff
@onready var rev_slider : Slider = $VBoxContainer/Sliders/Resonance
@onready var lpf_button : TextureButton = $VBoxContainer/Buttons/LPF
@onready var hpf_button : TextureButton = $VBoxContainer/Buttons/HPF

func _ready():
	lpf = AudioServer.get_bus_effect(bus_i, lpf_i)
	hpf = AudioServer.get_bus_effect(bus_i, hpf_i)

	_on_cutoff_value_changed(cut_slider.value)
	_on_resonance_value_changed(rev_slider.value)

func _on_lpf_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, lpf_i, lpf_button.button_pressed)
		
	if hpf_button.button_pressed:
		AudioServer.set_bus_effect_enabled(bus_i, hpf_i, false)
		hpf_button.button_pressed = false



func _on_hpf_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, hpf_i, hpf_button.button_pressed)
	
	if lpf_button.button_pressed:
		AudioServer.set_bus_effect_enabled(bus_i, lpf_i, false)
		lpf_button.button_pressed = false
		


func _on_cutoff_value_changed(value):
	lpf.cutoff_hz = value
	hpf.cutoff_hz = value


func _on_resonance_value_changed(value):
	lpf.resonance = value
	hpf.resonance = value
