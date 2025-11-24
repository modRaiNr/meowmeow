extends State

@export var player: CharacterBody3D

func Update(delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (player.head.transform.basis * player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		player.velocity.x = direction.x * player.speed
		player.velocity.z = direction.z * player.speed
	else:
		state_transition.emit(self, "Idle")
		player.velocity.x = lerp(player.velocity.x, direction.x * player.speed, delta * 7.0)
		player.velocity.z = lerp(player.velocity.z, direction.z * player.speed, delta * 7.0)
	
	if Input.is_action_just_pressed("pull"):
		state_transition.emit(self, "Throw")
		
	if Input.is_action_just_pressed("atk"):
		state_transition.emit(self, "Attack")
		
