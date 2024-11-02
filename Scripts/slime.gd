extends CharacterBody2D

@onready var ap =  $AnimationPlayer

func _physics_process(delta):
	var slime = $Sprite2D
	updateanimations(slime)
func updateanimations(slime):
	ap.play("idle")
