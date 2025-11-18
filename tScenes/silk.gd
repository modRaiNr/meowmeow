extends StaticBody3D


func _ready():
	$Timer.start()

func set_values(pos, rot):
	global_position = pos
	global_rotation = rot

func _on_timer_timeout() -> void:
	queue_free()
