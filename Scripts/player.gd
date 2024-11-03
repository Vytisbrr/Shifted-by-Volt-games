extends CharacterBody2D


signal healthChanged
@export var speed = 400
@export var gravity = 30
@export var jump_force = 300

@export var maxHealth = 3
@onready var currentHealth: int = maxHealth
@onready var HeartContainer = $CanvasLayer/Hearts
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var coyote_timer = $coyotetimer
var can_coyote_jump = false


func _physics_process(delta):
	if !is_on_floor() && (can_coyote_jump == false):
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() || can_coyote_jump:
			velocity.y = -jump_force
			if can_coyote_jump:
				can_coyote_jump = false
	
	
	var horizontal_direction = Input.get_axis("move left","move right")
	
	velocity.x = speed * horizontal_direction
	
	if horizontal_direction != 0:
		sprite.flip_h = (horizontal_direction == -1)
	
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor() && velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	updateanimations(horizontal_direction)
func updateanimations(horizotal_direction):
	if is_on_floor():
		if horizotal_direction == 0:
			ap.play("idle")
		else:
			ap.play("walk")
	else:
		if velocity.y < 0:
			ap.play("fall")
		elif velocity.y > 0:
			ap.play("fall")
func _on_coyotetimer_timeout():
	can_coyote_jump = false
	




func _on_hitbox_area_entered(area: Area2D):
	if area.name == "enemyarea":
		currentHealth -= 1
		if currentHealth < 0:
			currentHealth = 0
		healthChanged.emit(currentHealth)
func _ready():
	HeartContainer.setmaxHearts(maxHealth)
	HeartContainer.updateHearts(currentHealth)
	healthChanged.connect(HeartContainer.updateHearts)
