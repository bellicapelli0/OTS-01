extends Control


@onready var synth: Synth = get_tree().get_root().get_node("Synth")

func _on_edge_detection_pressed():

	
	
	var desired_curve : Array = synth._1D_convolution([-1,1,-1])
	desired_curve = Global.remap_to_limits(desired_curve)
	synth.start_animation(desired_curve)
	


