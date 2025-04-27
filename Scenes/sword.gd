extends Node2D
@onready var ap = $AnimationPlayer
func _process(delta):
	ap.play("default")


func _on_pickuparea_area_entered(area: Area2D):
	if area.name == "playerhitbox":
		hide()
		queue_free()
