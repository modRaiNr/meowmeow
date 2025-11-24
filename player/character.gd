extends CharacterBody3D

var speed
const WALK_SPEED = 2.0
const SPRINT_SPEED = 3.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.002

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 60.0
const FOV_CHANGE = 4

var on_crouch: bool = false

@onready var sm: RigidBody3D = $Head/Hand/SewMachine

@onready var head = $Head
@onready var camera = $Head/Camera3D

@onready var fsm: FiniteStateMachine = $FSM

@onready var hand: Marker3D = $Head/Hand
@onready var raycast: RayCast3D = $Head/Camera3D/RayCast3D

signal hint_show(sew_pos: Vector3, time_left: float)

func _ready():
	Globals.connect("sew_trigger", func(): hint_show.emit())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Head/Hand/SewMachine.connect("back", func(): $Head/Hand/SewMachine.rotation = Vector3(deg_to_rad(-56.8), deg_to_rad(14.3), deg_to_rad(-28.2)))

func get_sew_back(sew_pos: Vector3, _time_left: float):
	var tween: Tween = create_tween()
	
	tween.stop()
	tween.tween_property(self, "global_position", sew_pos, 0.5)
	tween.play()

func _input(event):
	if Input.is_action_just_pressed("esc"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))


func _physics_process(delta):
	$UI/State/Label.text = "STATE: %s" % fsm.current_state.name

	t_bob += delta * velocity.length()
	camera.transform.origin = _headbob(t_bob)

	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
