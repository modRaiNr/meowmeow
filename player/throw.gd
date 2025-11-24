extends State

@export var player: CharacterBody3D
var fly_transition: bool = false

func Enter():
	player.connect("hint_show", prepare_to_fly)
	player.sm.pull($"../../Head/Camera3D/Area3D".global_rotation, player.speed)
	

func Update(delta: float):
	if fly_transition:
		if Input.is_action_just_pressed("space"):
			state_transition.emit(self, "Fly")
	
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (player.head.transform.basis * player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			player.velocity.x = direction.x * player.speed
			player.velocity.z = direction.z * player.speed
		else:
			player.velocity.x = lerp(player.velocity.x, direction.x * player.speed, delta * 7.0)
			player.velocity.z = lerp(player.velocity.z, direction.z * player.speed, delta * 7.0)
	

func prepare_to_fly(a, b):
	$"../../UI/Hint".visible = true
	fly_transition = true
