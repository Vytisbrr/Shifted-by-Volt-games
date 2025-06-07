extends Node

@onready var player = $"../Wrigg"
@onready var worldroot = $"../worldroot"
var savepath = "user://save.tres"
func save_game():
	var saved_game:SavedGame = SavedGame.new()
	
	saved_game.player_health = player.currentHealth
	saved_game.player_potions = player.Hppickups
	saved_game.player_position = player.global_position
	var saved_data:Array[SavedData] = []
	get_tree().call_group("game_events", "on_save_game", saved_data)
	saved_game.saved_data = saved_data
	for slime in get_tree().get_nodes_in_group("mediumslime"):
		saved_game.medium_slime_positions.append(slime.global_position)
	ResourceSaver.save(saved_game, "user://save.tres")
func load_game():
	var saved_game:SavedGame = load("user://save.tres")
	
	player.global_position = saved_game.player_position
	player.Hppickups = saved_game.player_potions
	player.currentHealth = saved_game.player_health
	
	
	get_tree().call_group("game_events", "on_before_load_game")
	
	await get_tree().process_frame
	for item in saved_game.saved_data:
		var scene = load(item.scene_path) as PackedScene
		var restored_node = scene.instantiate()
		worldroot.add_child(restored_node)
		
		if restored_node.has_method("on_load_game"):
			restored_node.on_load_game(item)
		
