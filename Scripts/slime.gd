extends Node2D

const SPEED=60

var direction = 1

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft


@onready var ap =  $AnimationPlayer
@onready var area = $enemyarea

func _physics_process(delta):
	position.x += direction * SPEED * delta
	var slime = $Sprite2D
	updateanimations(slime)
func updateanimations(slime):
	ap.play("idle")
	
func _process(delta):
	if ray_cast_right. is_colliding():
		direction = -1
	if ray_cast_left. is_colliding():
		direction = 1
