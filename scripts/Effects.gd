extends Control


var del : AudioEffectDelay
var rev : AudioEffectReverb

var bus_i = 0
var del_i = 2
var rev_i = 4


var rev_value : float
var chr_value : float
var del_value : float
var danger_score = 0
@export var danger_threshold = 100

@onready var del_slider : Slider = $HBoxContainer/Delay/DelSlider
@onready var rev_slider : Slider = $HBoxContainer/Reverb/RevSlider
@onready var del_button : TextureButton = $HBoxContainer/Delay/DelButton
@onready var rev_button : TextureButton = $HBoxContainer/Reverb/RevButton
@onready var chr_slider : Slider = $"../Chorus/Voices"
@onready var caution : TextureRect = $Caution

func _ready():
	del = AudioServer.get_bus_effect(bus_i, del_i)
	rev = AudioServer.get_bus_effect(bus_i, rev_i)
	
	_on_del_slider_value_changed(del_slider.value)
	_on_rev_slider_value_changed(rev_slider.value)


func _on_del_button_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, del_i, del_button.button_pressed)


func _on_rev_button_pressed():
	AudioServer.set_bus_effect_enabled(bus_i, rev_i, rev_button.button_pressed)


func _on_del_slider_value_changed(value):
	if value == del_slider.min_value:
		del_button.button_pressed = false
		AudioServer.set_bus_effect_enabled(bus_i, del_i, false)
	elif not del_button.button_pressed:
		del_button.button_pressed = true
		AudioServer.set_bus_effect_enabled(bus_i, del_i, true)
	del.tap1_level_db = value
	del.tap2_level_db = value * 2


func _on_rev_slider_value_changed(value):
	if value == rev_slider.min_value:
		rev_button.button_pressed = false
		AudioServer.set_bus_effect_enabled(bus_i, rev_i, false)
	elif not rev_button.button_pressed:
		rev_button.button_pressed = true
		AudioServer.set_bus_effect_enabled(bus_i, rev_i, true)
	rev.wet = remap(value,
	rev_slider.min_value,
	rev_slider.max_value,
	0.1,
	0.5)
	
	
func _process(_delta):
	if rev_slider.value > danger_threshold and rev_button.button_pressed:
		if (del_button.button_pressed or chr_slider.value>0) or rev_slider.value==rev_slider.max_value:
			caution.texture.region.position.y = 32
			caution.tooltip_text = "High Reverb is bugged\nwith complex waves\nor other effects"
			return
	caution.texture.region.position.y = 0
	caution.tooltip_text = ""
		
	
