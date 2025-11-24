extends State

@export var player: CharacterBody3D

func Update(_delta: float):
	var input_dir = Input.get_vector("left", "right", "up", "down")
	if input_dir:
		if Input.is_action_pressed("sprint"):
			state_transition.emit(self, "Run")
			player.speed = player.SPRINT_SPEED
		else:
			state_transition.emit(self, "Run")
			player.speed = player.WALK_SPEED
	
	if Input.is_action_just_pressed("atk"):
		state_transition.emit(self, "Attack")
