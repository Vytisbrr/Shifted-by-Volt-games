extends Node2D
@onready var hppickup = $Sprite2D
@onready var ap = $AnimationPlayer
@onready var hparea = $Healthpickup
@onready var respawntimer = $respawn
@onready var item = $Healthpickup/CollisionShape2D
func _process(delta):
	updateanimations(hppickup)
func updateanimations(hppickup):
	ap.play("idle")


func _on_healthpickup_area_entered(area: Area2D):
	if area.name == "playerhitbox":
		item.call_deferred("is_disabled", true)
		hide()
		respawntimer.start()

func _on_respawn_timeout():
	item.call_deferred("is_disabled", false)
	show()
