extends Node2D
@onready var player = $Wrigg
@onready var saveload = $savingnode
func _process(delta: float):
	if Input.is_action_just_pressed("Save"):
		saveload.save_game()
	if Input.is_action_just_pressed("load"):
		saveload.load_game()
