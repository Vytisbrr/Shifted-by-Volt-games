extends CharacterBody2D

@export var speed = 400
@export var jumpheight = 700
@export var gravity = 20
@onready var stumpy = $Sprite2D
@onready var untiljumptimer = $untiljumptimer
@onready var removevelocitytimer = $removevelocitytimer
@export var min_jump_timer_duration = 1.0
@export var max_jump_timer_duration = 5.0
@onready var ap = $AnimationPlayer
@onready var hurtbox = $hurtbox
@onready var deathsound = $death
@export var hp = 5
var canjump = false
var made_timer = false
var direction: float
var next_direction = 1.0
var numoftimessamedir: int = 0
var last_jump_direction: float = 0.0
var flipsprite:bool
var dead = false
@onready var vision = $vision
var distancetoplayer:Vector2
var player
func _ready():
	if untiljumptimer:
		untiljumptimer.timeout.connect(_on_untiljumptimer_timeout)
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity
		if velocity.y > 3000:
			velocity.y = 3000
	move_and_slide()
	if is_on_floor() and canjump && not dead:
		velocity.x = speed * direction
		velocity.y = -jumpheight
		ap.play("jump")
		removevelocitytimer.start()
	elif is_on_floor() and not canjump and not made_timer && not dead:
		made_timer = true 
		
		var chosen_raw_direction = randi_range(-1, 1)
		
		if chosen_raw_direction == 0:
			direction = next_direction
			next_direction = -next_direction
		else:
			direction = float(chosen_raw_direction)
		if direction == last_jump_direction and direction != 0:
			numoftimessamedir += 1
		else:
			numoftimessamedir = 0
		if numoftimessamedir >= 2 and direction != 0:
			next_direction = -direction
		last_jump_direction = direction
		start_random_until_jump_timer()
	if direction == -1 && flipsprite && not is_on_floor():
		stumpy.flip_h = true
	if direction == 1 && is_on_floor():
		stumpy.flip_h = false
	if is_on_floor() and not canjump:
		velocity.x = 0
	if velocity.x == 0 && not dead:
		ap.play("idle")
		flipsprite = false
	else:
		flipsprite = true

func start_random_until_jump_timer():
	if untiljumptimer:
		if untiljumptimer.is_stopped():
			var random_wait_time = randf_range(min_jump_timer_duration, max_jump_timer_duration)
			untiljumptimer.wait_time = random_wait_time
			untiljumptimer.one_shot = true
			untiljumptimer.start()
		
func _on_untiljumptimer_timeout():
	canjump = true
	made_timer = false

func _on_removevelocitytimer_timeout():
	canjump = false
func _on_hurtbox_area_entered(area: Area2D):
	if area.name == "Swordhitboxdefault":
		hp -= 1
		if hp <= 0:
			stumpy.flip_h = false
			hp = 0
			ap.play("death")
			dead = true
			deathsound.play()
