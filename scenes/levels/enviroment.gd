extends Spatial
var res_loader : ResourceInteractiveLoader = null
var loading_thread : Thread = null
#signal quit
#warning-ignore:unused_signal
signal replace_main_scene # Useless, but needed as there is no clean way to check if a node exposes a signal

export (PackedScene) var cliffs
export (PackedScene) var fish
export (PackedScene) var hitFx
export (PackedScene) var gems
export (PackedScene) var gotItemIcon
export (PackedScene) var treasureBox
export (Array, PackedScene) var treasureBoxSceneArr
export (PackedScene) var mines

onready var startPlayer = $startAnim
onready var wallAnim = $bgCont/wallAnim
onready var oceanAnim = $bgCont/oceanAnim
onready var spawnTimer = $spawnTimer
onready var itemSpawner = $itemSpawner
onready var treasureTimer = $treasureTimer
var ddbuug

# start page Art

func _ready():
	ddbuug = GSignals.connect('instHitFx', self, 'inst_hit_fx')

	ddbuug = GSignals.connect('spawnGotItem', self, 'spawn_item_icon')
	ddbuug = GSignals.connect('gotTreasureBox', self, 'got_treasure_box')
	ddbuug = GSignals.connect('gameOver', self, 'game_over')
	ddbuug = GSignals.connect('stopResume', self, 'stop_resume')
	yield(get_tree().create_timer(.7), "timeout")
	startPlayer.play("start")
	spawnTimer.wait_time = rand_range(2,4)
	spawnTimer.start()
	treasureTimer.wait_time = 7

func _on_startAnim_animation_finished(anim_name):
	if anim_name == 'start':
		wallAnim.play("wallMov")
		oceanAnim.play("oceanMov")
		itemSpawner.start()
		treasureTimer.start()

func _on_destroyArea_area_entered(area):
	if area.is_in_group('obstacle') or area.is_in_group('items'):
		area.get_parent().queue_free()

###################################################### enemies
func spawn_cliffs():
	var c = cliffs.instance()
	add_child(c)

func spawn_fishes():
	var f = fish.instance()
	add_child(f)

func spawn_mines():
	var m = mines.instance()
	add_child(m)
###################################################### enemies

func spawn_gems():
	var g = gems.instance()
	add_child(g)

func spawn_treasure_box():
	var tb = treasureBox.instance()
	add_child(tb)

func spawn_item_icon(num, from, to):
	var g = gotItemIcon.instance()
	add_child(g)
	g.set_item(num)
	g.tween_move(from, to)

func inst_hit_fx(pos, scal):
	var h = hitFx.instance()
	h.translation = pos
	add_child(h)

func got_treasure_box():
	var randNum = floor(rand_range(0,2))
	var tb = treasureBoxSceneArr[randNum].instance()
	add_child(tb)
	stop_resume('stop')

func _on_spawnTimer_timeout():
	if GVariables.changeSpawnCount < 200:
		GVariables.changeSpawnCount += 1
	else:
		GVariables.changeSpawnCount = 21
	if GVariables.changeSpawnCount < 10:
		var randNum = rand_range(2,3)
		spawnTimer.wait_time = randNum
		spawn_cliffs()
	elif GVariables.changeSpawnCount > 10 and GVariables.changeSpawnCount <= 40:
		var randNum = rand_range(1,3)
		spawnTimer.wait_time = randNum
		spawn_fishes()
	elif GVariables.changeSpawnCount > 40 and GVariables.changeSpawnCount <= 80:
		var randNum = rand_range(1,2)
		spawnTimer.wait_time = randNum
		spawn_mines()
	elif GVariables.changeSpawnCount > 80:
		var randNum = rand_range(.7,1.5)
		spawnTimer.wait_time = randNum
		spawn_fishes()
		yield(get_tree().create_timer(rand_range(0.2, 0.7)), "timeout")
		spawn_mines()

func stop_resume(stopResume):
	if stopResume == 'resume':
		GVariables.gameOn = true
		spawnTimer.start()
		itemSpawner.start()
		treasureTimer.start()
		oceanAnim.play("oceanMov")
		wallAnim.play()
		GSignals.life_timer('start')
	else:
		GVariables.gameOn = false
		spawnTimer.stop()
		itemSpawner.stop()
		treasureTimer.stop()
		oceanAnim.stop(false)
		wallAnim.stop(false)
		GSignals.life_timer('stop')

func _on_itemSpawner_timeout():
	var randNum = rand_range(2,4)
	itemSpawner.wait_time = randNum
	spawn_gems()

func _on_treasureTimer_timeout():
	var randNum = rand_range(5,15)
	treasureTimer.wait_time = randNum
	spawn_treasure_box()

func game_over():
	stop_resume('stop')
	inst_transition_page()

func inst_transition_page():
	var i = preload('res://scenes/ui/transitionPage.tscn').instance()
	add_child(i)
