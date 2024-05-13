extends Node2D

@export var player_scene : PackedScene

func _ready():
	if not is_multiplayer_authority():
		return
		
	multiplayer.peer_connected.connect(add_player)
	add_player(1)

func add_player(id):
	var player = player_scene.instantiate()
	player.name = str(id)
	get_node("/root/Game").add_child(player)
