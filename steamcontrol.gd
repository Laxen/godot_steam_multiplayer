extends Control

var peer = SteamMultiplayerPeer.new()

func _ready():
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))
	Steam.steamInitEx()
	
	multiplayer.connected_to_server.connect(connected_to_server)

@rpc("any_peer", "call_local")
func start_game():
	var scene = load("res://game.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func _process(delta):
	Steam.run_callbacks()

func _on_host_pressed():
	peer.lobby_created.connect(_on_lobby_created)
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer

func _on_lobby_created(connect, id):
	if not connect:
		return
		
	Steam.setLobbyData(id, "name", str("SteamMultiplayer Lobby of Lax"))
	Steam.setLobbyJoinable(id, true)
	print("Lobby ", id, " created")
	
	start_game()

func _on_join_pressed():
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()

func connected_to_server():
	print("connected")

func _on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		if lobby_name == "SteamMultiplayer Lobby of Lax":
			peer.connect_lobby(lobby)
			multiplayer.multiplayer_peer = peer
			print("Joined lobby ", lobby)
			start_game()
			return
			
	print("ERROR: Couldn't find lobby")
