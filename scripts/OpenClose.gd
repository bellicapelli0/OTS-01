extends TextureButton


@onready var player = $"../Frame/AnimationPlayer"

func _process(_delta):
	if disabled:
		return
	if Input.is_action_just_pressed("Open"):
		if not button_pressed:
			button_pressed = false
			disabled = true
			player.play("open")
		else:
			button_pressed = true
			disabled = true
			player.play("close")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		disabled = false
		button_pressed = true
	if anim_name == "close":
		disabled = false
		button_pressed = false
		
func _on_pressed():
	disabled = true
	if button_pressed:
		player.play("open")
	else:
		player.play("close")
	


func _on_button_down():
	disabled = true
	if button_pressed:
		player.play("close")
	else:
		player.play("open")
	
