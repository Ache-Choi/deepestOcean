extends Spatial

onready var animPlayer = $playerMesh/AnimationPlayer
onready var playerMesh = $playerMesh
onready var speed = 20
onready var xLimitFrom = -11.001
onready var xLimitTo   = 11.001
onready var yLimitFrom = -25.001
onready var yLimitTo   = 12.011
onready var particleBubbles = $playerMesh/CPUParticles

func _ready():
	animPlayer.play("swim")
	yield(get_tree().create_timer(.4), "timeout")
	animPlayer.play("dive")

func _physics_process(delta):
	if GVariables.gameOn:
		player_movement(delta)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'dive':
		animPlayer.play("swimDiving")
		yield(get_tree().create_timer(.4), "timeout")
		particleBubbles.emitting = true

func player_movement(d):
	if Input.is_action_pressed("left"):
		if playerMesh.translation.x <= xLimitFrom:
			playerMesh.translation.x = xLimitFrom
		else:
			playerMesh.global_transform.origin.x -= speed * d
	if Input.is_action_pressed("right"):
		if playerMesh.translation.x >= xLimitTo:
			playerMesh.translation.x = xLimitTo
		else:
			playerMesh.global_transform.origin.x += speed * d
	if Input.is_action_pressed("up"):
		if playerMesh.translation.y >= yLimitTo:
			playerMesh.translation.y = yLimitTo
		else:
			playerMesh.global_transform.origin.y += speed * d
	if Input.is_action_pressed("down"):
		if playerMesh.translation.y <= yLimitFrom:
			playerMesh.translation.y = yLimitFrom
		else:
			playerMesh.global_transform.origin.y -= speed * d


func _on_Area_area_entered(area):
	if area.is_in_group('obstacle'):
		GSignals.inst_hit_fx(playerMesh.global_transform.origin, 0)
		particleBubbles.emitting = false
		GVariables.gameOn = false
		GSignals.game_over()
		animPlayer.stop()
		GSignals.inst_sounds('gotHit')
	if area.is_in_group('items'):
		GSignals.spawn_got_item(area.get_parent().selfGemNum,
		area.get_parent().global_transform.origin, Vector3(-13,14,0))
		area.get_parent().queue_free()
		GSignals.inst_sounds('gotItem')
	if area.is_in_group('treasureBox'):
		area.get_parent().got_it()
		GSignals.inst_sounds('gotItem')
		
