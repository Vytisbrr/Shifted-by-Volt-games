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
@onready var hitsound = $hit
@onready var walksound = $walk
@onready var walksound2 = $walk2
@onready var walksound3 = $walk3
@export var hp = 5
@onready var vision = $vision
@onready var attackrange = $attackrange
@onready var stumpyhitbox = $stumpyhitbox
@onready var hitboxarea = $"stumpyhitbox/atctive_deactive area"
@onready var attackcooldown = $attackcooldowntimer
var canjump = false
var made_timer = false
var direction: float
var next_direction = 1.0
var numoftimessamedir: int = 0
var last_jump_direction: float = 0.0
var flipsprite:bool
var dead = false
var canattack = true
var canplayidlesound = true
func _ready():
	if untiljumptimer:
		untiljumptimer.timeout.connect(_on_untiljumptimer_timeout)
	if attackcooldown:
		attackcooldown.timeout.connect(_on_attackcooldown_timeout)
func _physics_process(delta):
	var overlapping_bodies = vision.get_overlapping_bodies()
	var attack_in_range = attackrange.get_overlapping_bodies()
	if overlapping_bodies.has(Playerid.player) && self.global_position.x < Playerid.player.global_position.x && not dead:
		direction = 1
	elif  overlapping_bodies.has(Playerid.player) && self.global_position.x > Playerid.player.global_position.x && not dead:
		direction = -1
	if attack_in_range.has(Playerid.player) && not dead:
		var distancetoplayer_x = abs(Playerid.player.global_position.x - self.global_position.x)
		if canattack == true && overlapping_bodies.has(Playerid.player) && is_on_floor():
			var randattackcooldown = randi_range(2, 3)
			attackcooldown.wait_time = randattackcooldown
			attackcooldown.one_shot = true
			canattack = false
			attackcooldown.start()
			hitboxarea.disabled = false
			var randomjump = randi_range(1,3)
			if randomjump == 1:
				walksound.play()
			if randomjump == 2:
				walksound2.play()
			if randomjump == 3:
				walksound3.play()
			velocity.x = min(distancetoplayer_x * 0.9, 750) * direction
			velocity.y = -jumpheight
			ap.play("jump")
		elif canattack == false && is_on_floor():
			hitboxarea.disabled = true
	else:
		hitboxarea.disabled = true
	if not is_on_floor():
		velocity.y += gravity
		if velocity.y > 3000:
			velocity.y = 3000
	move_and_slide()
	if is_on_floor() and canjump && not dead:
		var randomjump = randi_range(1,3)
		if randomjump == 1:
			walksound.play()
		if randomjump == 2:
			walksound2.play()
		if randomjump == 3:
			walksound3.play()
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
	if direction == -1 && not is_on_floor():
		stumpy.flip_h = true
	if direction == 1 && is_on_floor():
		stumpy.flip_h = false
	if is_on_floor() and not canjump:
		velocity.x = 0
	if velocity.x == 0 && not dead:
		ap.play("idle")
		var randomidle = randi_range(1,3)
		if randomidle == 1 && canplayidlesound == true:
			canplayidlesound = false
			walksound.play()
		if randomidle == 2 && canplayidlesound == true:
			canplayidlesound = false
			walksound2.play()
		if randomidle == 3 && canplayidlesound == true:
			canplayidlesound = false
			walksound3.play()

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
		if hp > 0:
			hitsound.play()
func _on_attackcooldown_timeout():
	canattack = true
func _on_walk_finished():
	canplayidlesound = true
func _on_walk_2_finished():
	canplayidlesound = true
func _on_walk_3_finished():
	canplayidlesound = true
