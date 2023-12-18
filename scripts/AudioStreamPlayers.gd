extends Node

@export var volume = -10
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.volume_db = volume
