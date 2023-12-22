extends Control

var lpf : AudioEffectLowPassFilter
var hpf : AudioEffectHighPassFilter

var bus_i = 0
var lpf_i = 0
var hpf_i = 1


func _ready():
	lpf = AudioServer.get_bus_effect(bus_i, lpf_i)
	hpf = AudioServer.get_bus_effect(bus_i, hpf_i)
	#$VBoxContainer/Buttons/LPF.disabled = true
	#$VBoxContainer/Buttons/LPF.button_pressed = true
	
	_on_cutoff_value_changed($VBoxContainer/Sliders/Cutoff.value)
	_on_resonance_value_changed($VBoxContainer/Sliders/Resonance.value)

func _on_lpf_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, lpf_i, $VBoxContainer/Buttons/LPF.button_pressed)
		
	if $VBoxContainer/Buttons/HPF.button_pressed:
		AudioServer.set_bus_effect_enabled(bus_i, hpf_i, false)
		$VBoxContainer/Buttons/HPF.button_pressed = false



func _on_hpf_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, hpf_i, $VBoxContainer/Buttons/HPF.button_pressed)
	
	if $VBoxContainer/Buttons/LPF.button_pressed:
		AudioServer.set_bus_effect_enabled(bus_i, lpf_i, false)
		$VBoxContainer/Buttons/LPF.button_pressed = false
		


func _on_cutoff_value_changed(value):
	if value <= $VBoxContainer/Sliders/Cutoff.min_value * 1.02:
		value = 0
	if value >= $VBoxContainer/Sliders/Cutoff.max_value * 0.98:
		value = 5000
	lpf.cutoff_hz = value
	hpf.cutoff_hz = value


func _on_resonance_value_changed(value):
	lpf.resonance = value
	hpf.resonance = value
