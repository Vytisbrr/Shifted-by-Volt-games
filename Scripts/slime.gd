extends CharacterBody2D

@onready var ap =  $AnimationPlayer
@onready var area = $Monsterhitbox

func _physics_process(delta):
	var slime = $Sprite2D
	updateanimations(slime)
func updateanimations(slime):
	ap.play("idle")
