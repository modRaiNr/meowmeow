extends CharacterBody3D

var hp: int = 3:
	set(value):
		hp = value
		if hp <= 0: queue_free()



func entered(body: Node3D) -> void:
	var color: Color = Color(1, 0, 1, 1)
	
	var new_material: StandardMaterial3D = StandardMaterial3D.new()
	new_material.albedo_color = color
	$MeshInstance3D.material_override = new_material
	
	$Timer.start()
	

func _on_timer_timeout() -> void:
	var color: Color = Color(1, 0, 0, 1)
	
	var new_material: StandardMaterial3D = StandardMaterial3D.new()
	new_material.albedo_color = color
	$MeshInstance3D.material_override = new_material
	
	hp-= 1


func area_entered(area: Area3D) -> void:
	var color: Color = Color(1, 0, 1, 1)
	
	var new_material: StandardMaterial3D = StandardMaterial3D.new()
	new_material.albedo_color = color
	$MeshInstance3D.material_override = new_material
	
	$Timer.start()
