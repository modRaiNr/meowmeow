extends RigidBody3D


@onready var silk_scene = preload("res://tScenes/silk.tscn")
@onready var animator: AnimationPlayer = $AnimationPlayer
var rot: Vector3

var active: bool = false

var collide_with_walls: bool = true

signal back

var throwen: bool = false

@onready var joint: PinJoint3D = $joint
var temp_joint: HingeJoint3D

var idx: int

@export var player: CharacterBody3D


func wall_up(body: Node3D) -> void:
	if throwen:
		change_state()
		Globals.emit_signal("sew_trigger", global_position, $Timer.time_left)
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
	throwen = !throwen

func _process(_delta: float) -> void:
	if active:
		$Timer2.start()
		active = false

func atk():
	collide_with_walls = false
	idx = randi_range(1, 2)
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
	
	reparent(get_tree().get_root())
	
	change_state()
	active = true
	linear_velocity = prot * speed * 4 + Vector3(0, 2, 0)
	
	$Timer.start()

func silk_clear():
	$Timer2.stop()
	$silkNew.scale.y = 1
	for child in $joints.get_children():
		$joints.remove_child(child)
		child.queue_free()

func pull_out() -> void:
	var tween: Tween = create_tween().set_parallel()
	var hand_pos: Vector3 = Vector3(-0.084, 0.112, 0)
	reparent(player.hand)
	
	tween.connect("finished", silk_clear)
	tween.connect("finished", func(): back.emit())
	
	tween.stop()
	tween.tween_property(self, "position", hand_pos, 1)
	tween.tween_property(self, "rotation", Vector3(100, 100, 100), 0.9)
	tween.play()
	
	if freeze == false:
		change_state()


func silk_spawn() -> void:
	
	$silkNew.scale.y += 1
	print($silkNew.scale.y)
	#var silk = silk_scene.instantiate()
	#
	#get_tree().get_root().add_child(silk)
	#$silks.add_child(silk)
	#if silk_count == 0:
		#silk.set_values(joint.global_position, joint.global_rotation)
		#joint.node_b = silk.get_path()
		#silk.joint.node_b = joint.node_b
	#else:
		
		#var prev_silk_joint: PinJoint3D = $silks.get_child(silk_count).joint if is_instance_valid($silks.get_child(silk_count)) else joint
		#
		#silk.set_values(prev_silk_joint.global_position, 
						#prev_silk_joint.global_rotation)
		#prev_silk_joint.node_b = silk.get_path()
	#silk_count += 1
	
	
	#if silk_count == 0:
		#joint.node_b = silk.get_path()
	#else:
		#temp_joint = HingeJoint3D.new()
		#$joints.add_child(temp_joint)
		#temp_joint.global_position = silk.pos
		#$Timer2.connect("timeout", temp_joint.queue_free)
		#temp_joint.node_a = joint.node_b
		#temp_joint.node_b = silk.get_path()
	#silk_count += 1
	
