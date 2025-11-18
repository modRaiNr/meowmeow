extends RigidBody3D


@onready var silk_scene = preload("res://tScenes/silk.tscn")
@onready var animator: AnimationPlayer = $AnimationPlayer
var rot: Vector3

var active: bool = false

var collide_with_walls: bool = true

signal back

var idx: int

#func _ready():
	#animator.connect("animation_finished", func(anim_name): animator.play_backwards("atk") if anim_name == "atk" else 0)

func wall_up(body: Node3D) -> void:
	if collide_with_walls:
		animator.play("wall")


func wall_down(body: Node3D) -> void:
	if collide_with_walls:
		animator.play_backwards("wall")

func change_state():
	lock_rotation = !lock_rotation
	freeze = !freeze

func _process(_delta: float) -> void:
	if active:
		$Timer2.start()
		active = false

func atk():
	idx = randi_range(1, 3)
	collide_with_walls = false
	animator.play("atk" + str(idx))
	$Timer3.start()

func atk_back() -> void:
	animator.play_backwards("atk" + str(idx))
	await animator.animation_finished
	collide_with_walls = true

func pull(dir: Vector3, speed: float, prot: Vector3):
	rot = global_rotation
	var tween: Tween = create_tween()
	tween.stop()
	tween.tween_property(self, "rotation:x", deg_to_rad(-90), 0.6)
	tween.tween_property(self, "position:z", 0.1, 0.6)
	tween.play()
	
	await tween.finished
	
	change_state()
	active = true
	#apply_central_impulse(dir * speed + Vector3(0, 1, 0))
	linear_velocity = transform.origin.normalized() * speed * 6 + Vector3(0, 0.5, 0)
	print(dir, speed)
	print(dir * speed * 0.5 + Vector3(0, 0.5, 0))
	
	$Timer.start()


func pull_out() -> void:
	var tween: Tween = create_tween().set_parallel()
	tween.connect("finished", func(): $Timer2.stop())
	tween.connect("finished", func(): back.emit())
	var hand_pos: Vector3 = Vector3(-0.084, 0.112, 0)
	tween.stop()
	#var hand_rot: Vector3 = get_parent().get_parent().global_rotation + Vector3(deg_to_rad(-56.8), deg_to_rad(14.3), deg_to_rad(-28.2))
	tween.tween_property(self, "position", hand_pos, 1)
	tween.tween_property(self, "rotation", Vector3(100, 100, 100), 0.9)
	tween.play()
	change_state()


func silk_spawn() -> void:
	var silk = silk_scene.instantiate()
	get_tree().get_root().add_child(silk)
	silk.set_values(global_position, global_rotation)
