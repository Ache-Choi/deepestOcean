extends Control

#onready var timer = $Timer
onready var animPlayer = $AnimationPlayer
onready var scoreNum = $scoreCount
onready var coinsCount = $coinCount
onready var gemsCount = $gemCount
onready var textureP = $lives/TextureProgress
onready var lifeTimer = $lives/lifeTimer
onready var depthTimer = $depthTimer

var dbug

func _ready():
#	dbug = GSignals.connect('updateLiveCount', self, 'update_lives')
	dbug = GSignals.connect('updateCoinsGems', self, 'update_gems_coins')
	dbug = GSignals.connect('updateOxyValue', self, 'update_oxygen_value')
	dbug = GSignals.connect('lifeTimer', self, 'life_timer')
	update_gems_coins()
	animPlayer.play("start")
	textureP.value = 100
	lifeTimer.wait_time = 0.1
	lifeTimer.start()
	
func life_timer(startStop):
	if startStop == 'start':
		lifeTimer.start()
		depthTimer.start()
	else:
		lifeTimer.stop()
		depthTimer.stop()

func update_oxygen_value(amount):
	textureP.value += amount

func _on_lifeTimer_timeout():
	textureP.value -= 0.2
	var twoThirds = ((textureP.max_value/3)*2)
	var third = textureP.max_value/3
	if textureP.value > twoThirds:
		textureP.tint_progress = '00ff30'
	elif textureP.value > third and textureP.value <= twoThirds:
		textureP.tint_progress = 'fff300'
	else:
		textureP.tint_progress = 'ff0000'
	if textureP.value <= 0:
		lifeTimer.stop()
		GVariables.gameOn = false
		GSignals.game_over()

func update_gems_coins():
	coinsCount.text = 'x ' + str(GVariables.coins)
	gemsCount.text = 'x ' + str(GVariables.gems)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'start':
		GVariables.gameOn = true
		depthTimer.start()
		scoreNum.text = str(3)

func _on_depthTimer_timeout():
	if GVariables.gameOn:
		var num = int(scoreNum.text)
		scoreNum.text = str(num+1)
		GVariables.depth = num
	else:
		depthTimer.stop()
		
func _on_pauseBtn_button_up():
	GSignals.inst_sounds('click')
	var p = preload('res://scenes/ui/pause.tscn').instance()
	add_child(p)
	get_tree().paused = not get_tree().paused
