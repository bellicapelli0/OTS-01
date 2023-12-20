extends Panel

var lpf : AudioEffectLowPassFilter
var hpf : AudioEffectHighPassFilter

var bus_i = 0
var lpf_i = 1
var hpf_i = 2


func _ready():
	lpf = AudioServer.get_bus_effect(bus_i, lpf_i)
	hpf = AudioServer.get_bus_effect(bus_i, hpf_i)
	$VBoxContainer/Buttons/LPF.disabled = true
	
	_on_cutoff_value_changed($VBoxContainer/Sliders/Cutoff.value)
	_on_resonance_value_changed($VBoxContainer/Sliders/Resonance.value)

func _on_lpf_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, lpf_i, true)
	AudioServer.set_bus_effect_enabled(bus_i, hpf_i, false)
	$VBoxContainer/Buttons/LPF.disabled = true
	$VBoxContainer/Buttons/HPF.disabled = false
	


func _on_hpf_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, lpf_i, false)
	AudioServer.set_bus_effect_enabled(bus_i, hpf_i, true)
	$VBoxContainer/Buttons/LPF.disabled = false
	$VBoxContainer/Buttons/HPF.disabled = true


func _on_cutoff_value_changed(value):
	lpf.cutoff_hz = value
	hpf.cutoff_hz = value


func _on_resonance_value_changed(value):
	lpf.resonance = value
	hpf.resonance = value
