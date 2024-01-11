extends Node

@export var volume = -10

func _ready():
	for child in get_children():
		child.volume_db = volume
