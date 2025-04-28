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
		hide()
		Isdisabledhppickup.isdisabled = true
		respawntimer.start()

func _on_respawn_timeout():
	Isdisabledhppickup.isdisabled = false
	show()
