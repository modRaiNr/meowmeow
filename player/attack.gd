extends State

@export var player: CharacterBody3D


func Enter():
	player.sm.atk()
