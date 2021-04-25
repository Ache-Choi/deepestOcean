extends Node

func _ready():
	$AnimationPlayer.play("start")
	$AudioStreamPlayer.playing = true
