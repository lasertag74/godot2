extends Node2D

var current_spawn_location_instance_number = 1
var current_player_for_spawn_location_number = null

func _ready() -> void:
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

	# Assign the local player to the UI after all players are in the scene
	for player in Persistent_nodes.get_children():
		if player.is_in_group("Player") and player.name == str(get_tree().get_network_unique_id()):
			Global.ui.player_ref = player

	if get_tree().is_network_server():
		setup_players_positions()


func setup_players_positions() -> void:
	for player in Persistent_nodes.get_children():
		if player.is_in_group("Player"):
			for spawn_location in $Spawn_locations.get_children():
				if int(spawn_location.name) == current_spawn_location_instance_number and current_player_for_spawn_location_number != player:
					player.rpc("update_position", spawn_location.global_position)
					current_spawn_location_instance_number += 1
					current_player_for_spawn_location_number = player

sync func spawn_medkit(index):
	var health_pack_scene = load("res://Scenes/HealthPack.tscn")
	var health_pickup = health_pack_scene.instance()
	var spawn_location = $Medkit_locations.get_node(str(index))
	health_pickup.global_position = spawn_location.global_position
	add_child(health_pickup)

func _player_disconnected(id) -> void:
	if Persistent_nodes.has_node(str(id)):
		Persistent_nodes.get_node(str(id)).username_text_instance.queue_free()
		Persistent_nodes.get_node(str(id)).queue_free()
	
func _on_HealthSpawnTimer_timeout():
	if get_tree().is_network_server():
		var random_node = (randi() % 8) + 1
		rpc("spawn_medkit", random_node)
