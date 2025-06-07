extends Node

@onready var player = $"../Wrigg"
@onready var worldroot = $"../worldroot"
var savepath = "user://save.tres"
func save_game():
	var saved_game:SavedGame = SavedGame.new()
	
	saved_game.player_health = player.currentHealth
	saved_game.player_potions = player.Hppickups
	saved_game.player_position = player.global_position
	for slime in get_tree().get_nodes_in_group("slime"):
		saved_game.small_slime_positions.append(slime.global_position)
	ResourceSaver.save(saved_game, "user://save.tres")
func load_game():
	var saved_game:SavedGame = load("user://save.tres")
	
	player.global_position = saved_game.player_position
	player.Hppickups = saved_game.player_potions
	player.currentHealth = saved_game.player_health
	
	var existing_small_slimes_to_delete = get_tree().get_nodes_in_group("slime").duplicate()
	
	for slime in existing_small_slimes_to_delete:
		if is_instance_valid(slime):
			slime.queue_free()
	
	await get_tree().process_frame
	for position in saved_game.small_slime_positions:
		var smallslimescene = preload("res://Scenes/smallslime.tscn")
		var new_small_slime = smallslimescene.instantiate()
		worldroot.add_child(new_small_slime)
		new_small_slime.global_position = position
