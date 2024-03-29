extends Control


var unscrewed_n = 0
var screws : Array = []

func _ready():
	screws.append($Screw)
	screws.append($Screw2)
	screws.append($Screw3)
	screws.append($Screw4)
	
	for i in 6:
		_on_timer_timeout()

func _on_screw1_unscrewed():
	screws.erase($Screw)
	$AnimationPlayer.play("leave1")
	_unscrewed()

func _on_screw_2_unscrewed():
	screws.erase($Screw2)	
	$AnimationPlayer.play("leave2")
	_unscrewed()

func _on_screw_3_unscrewed():
	screws.erase($Screw3)
	$AnimationPlayer.play("leave3")
	_unscrewed()

func _on_screw_4_unscrewed():
	screws.erase($Screw4)
	$AnimationPlayer.play("leave4")
	_unscrewed()

func _unscrewed():
	unscrewed_n += 1
	if unscrewed_n == 4:
		$"../AnimationPlayer".play("open")
		$"../../OpenClose".show()

func _process(_delta):
	if Input.is_action_just_pressed("Open"):
		_unscrewed()
		_unscrewed()
		_unscrewed()
		_unscrewed()
		hide()
		
func unscrew_random():
	if len(screws) == 0:
		return
	var screw = screws.pick_random()
	screw._on_texture_button_pressed()
	
	
var t_rand_range = 0.65
var t_rand_base = 0.0

func _on_timer_timeout():
	if len(screws) == 0:
		$Timer.queue_free()
		return
	var screw = screws.pick_random()
	var animation_speed = randf() * t_rand_range + t_rand_base
	screw.material.set_shader_parameter("animationSpeed", animation_speed)
