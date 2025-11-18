extends RigidBody3D

@onready var joint: PinJoint3D = $PinJoint3D


func _ready():
	$Timer.start()
	
func set_values(pos, rot):
	global_position = pos
	global_rotation = rot

func _on_timer_timeout() -> void:
	print(1, joint.node_a)
	print(2, joint.node_b)
	queue_free()
