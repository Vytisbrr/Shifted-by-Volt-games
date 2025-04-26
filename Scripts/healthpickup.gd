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
	area.name = "playerhitbox"
	respawntimer.start()
	hparea.PROCESS_MODE_DISABLED
	hide()


func _on_respawn_timeout():
	hparea.PROCESS_MODE_ALWAYS
	show()
