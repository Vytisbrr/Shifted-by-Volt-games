extends Node2D
@onready var hppickup = $Sprite2D
@onready var ap = $AnimationPlayer
@onready var hparea = $Healthpickup
@onready var respawntimer = $respawn
@onready var CollisionShape = $Healthpickup/CollisionShape2D
func _process(delta):
	updateanimations(hppickup)
func updateanimations(hppickup):
	ap.play("idle")


func _on_healthpickup_area_entered(area: Area2D):
	area.name = "playerhitbox"
	respawntimer.start()
	hparea.remove_child(CollisionShape)
	hide()


func _on_respawn_timeout():
	hparea.add_child(CollisionShape)
	show()
