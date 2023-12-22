extends Control


var unscrewed_n = 0


func _on_screw1_unscrewed():
	$AnimationPlayer.play("leave1")
	_unscrewed()

func _on_screw_2_unscrewed():
	$AnimationPlayer.play("leave2")
	_unscrewed()

func _on_screw_3_unscrewed():
	$AnimationPlayer.play("leave3")
	_unscrewed()

func _on_screw_4_unscrewed():
	$AnimationPlayer.play("leave4")
	_unscrewed()

func _unscrewed():
	unscrewed_n += 1
	if unscrewed_n == 4:
		$"../AnimationPlayer".play("open")
		$"../../OpenClose".show()
