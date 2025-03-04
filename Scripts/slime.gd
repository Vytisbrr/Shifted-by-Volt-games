extends Node2D

const SPEED=60

@onready var ap =  $AnimationPlayer
@onready var area = $enemyarea

func _physics_process(delta):
	position.x += SPEED * delta
	var slime = $Sprite2D
	updateanimations(slime)
func updateanimations(slime):
	ap.play("idle")
	
