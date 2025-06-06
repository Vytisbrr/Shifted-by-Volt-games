extends TextureProgressBar
@onready var player = get_parent()
# Called when the node enters the scene tree for the first time.

func _process(delta):
	max_value = player.maxHealth
	value = player.currentHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
