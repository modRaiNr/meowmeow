extends RigidBody3D


@onready var silk_scene = preload("res://tScenes/silk.tscn")
@onready var animator: AnimationPlayer = $AnimationPlayer
var rot: Vector3

var active: bool = false

var collide_with_walls: bool = true

signal back

var silk_count: int = 0
@onready var joint: HingeJoint3D = $joint
var temp_joint: HingeJoint3D

var idx: int


func wall_up(body: Node3D) -> void:
	if animator.is_playing():
		return
	if collide_with_walls and !active:
		animator.play("wall")


func wall_down(body: Node3D) -> void:
	if animator.is_playing():
		return
	if collide_with_walls and !active:
		await get_tree().create_timer(0.5).timeout
		animator.play_backwards("wall")

func change_state():
	lock_rotation = !lock_rotation
	freeze = !freeze

func _process(_delta: float) -> void:
	if active:
		$Timer2.start()
		active = false

func atk():
	collide_with_walls = false
	idx = randi_range(1, 3)
	animator.play("atk" + str(idx))
	$Timer3.start()

func atk_back() -> void:
	animator.play_backwards("atk" + str(idx))
	await animator.animation_finished
	collide_with_walls = true

func pull(dir: Vector3, speed: float, prot: Vector3):
	if dir == Vector3.ZERO:
		return
	rot = global_rotation
	var tween: Tween = create_tween()
	tween.stop()
	tween.tween_property(self, "rotation:x", deg_to_rad(-90), 0.6)
	tween.tween_property(self, "position:z", 0.1, 0.6)
	tween.play()
	
	await tween.finished
	
	change_state()
	active = true
	linear_velocity = dir * speed * 10 + Vector3(0, 1, 0)
	
	$Timer.start()

func silk_clear():
	$Timer2.stop()
	silk_count = 0
	for child in $joints.get_children():
		$joints.remove_child(child)
		child.queue_free()

func pull_out() -> void:
	var tween: Tween = create_tween().set_parallel()
	var hand_pos: Vector3 = Vector3(-0.084, 0.112, 0)
	
	tween.connect("finished", silk_clear)
	tween.connect("finished", func(): back.emit())
	
	tween.stop()
	tween.tween_property(self, "position", hand_pos, 1)
	tween.tween_property(self, "rotation", Vector3(100, 100, 100), 0.9)
	tween.play()
	
	change_state()


func silk_spawn() -> void:
	var silk = silk_scene.instantiate()
	
	#get_tree().get_root().add_child(silk)
	$silks.add_child(silk)
	silk.set_values($spawn_pos.global_position, global_rotation)
	if silk_count == 0:
		joint.node_b = silk.get_path()
	else:
		temp_joint = HingeJoint3D.new()
		$joints.add_child(temp_joint)
		$Timer2.connect("timeout", temp_joint.queue_free)
		temp_joint.node_a = joint.node_b
		temp_joint.node_b = silk.get_path()
	silk_count += 1
	
