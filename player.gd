extends CharacterBody2D

const BULLET = preload("res://bullet.tscn")
const SPEED = 300.0

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
	
func _input(event):
	if !is_multiplayer_authority():
		return

	if event.is_action_pressed("shoot"):
		shoot.rpc_id(1, get_global_mouse_position())

@rpc("any_peer", "call_local", "reliable")
func shoot(mouse_position):
	var bullet = BULLET.instantiate()
	bullet.global_position = global_position
	bullet.look_at(mouse_position)
	get_node("/root/Game").add_child(bullet, true)
