extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Wrigg":
		print("You Died!")
		timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	#EOE
