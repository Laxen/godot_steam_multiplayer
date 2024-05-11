extends CharacterBody2D

const SPEED = 300.0
#@onready var cam = $Camera2D

func _ready():
	#cam.enabled = is_multiplayer_authority()
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
