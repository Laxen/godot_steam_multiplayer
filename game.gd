extends Node2D

@export var player_scene : PackedScene

func _ready():
	# Spawns players and sets the node name to their ID, which in turn is used
	# in the player script to set multiplayer authority
	var index = 0
	for pid in GameManager.players:
		var player = player_scene.instantiate()
		print("instant")
		player.name = str(pid)
		player.global_position.x = player.global_position.x + 100 * index
		add_child(player)
		index += 1
