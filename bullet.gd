extends Area2D

const SPEED = 1000
const DESPAWN_RANGE = 1000

var travelled_distance = 0

func _physics_process(delta):
	if !is_multiplayer_authority():
		return
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > DESPAWN_RANGE:
		queue_free()
