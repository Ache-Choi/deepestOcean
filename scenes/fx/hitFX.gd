extends Spatial


func _ready():
	$AnimationPlayer.play("explode")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'explode':
		self.queue_free()
