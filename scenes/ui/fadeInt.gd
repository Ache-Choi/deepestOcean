extends Node2D

export (String) var animeName
var ddb

func _ready():
	$AnimationPlayer.play("fadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	$Timer.start()
	ddb = anim_name

func _on_Timer_timeout():
	self.queue_free()
