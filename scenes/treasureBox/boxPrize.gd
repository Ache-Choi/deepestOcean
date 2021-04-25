extends Node2D
export (PackedScene) var singleBox

onready var boxGrid = []
onready var boxOffset = Vector2(105,105)
onready var bCont = $boxContainer
onready var bstartP = $boxStartPos
onready var textCont = $textcontainer
onready var gameDescrip = $descriptionMsg
onready var WLtext = $textcontainer/winLoseText
onready var descpText = $textcontainer/descripText

onready var animPlayer01 = $AnimationPlayer
onready var animPlayer02 = $AnimationPlayer2
onready var countPosNum = -1

onready var itemBtnsCont = $gemBtnCont/gemBtns
onready var itemsSprite  = $gemBtnCont/ggSprite
onready var finalBtns  = $gemBtnCont/homeADbtnCont
onready var gemCount = $gemBtnCont/gemInBoxCount
onready var tween  = $Tween
onready var newCount
onready var adClicked = false
onready var goBackBtn = $gemBtnCont/goBack


onready var debugger2

func _ready():
	goBackBtn.disabled = false
	debugger2 = GSignals.connect('chooseItemMiniGame', self, '_end_mini_game')
	newCount = 0
	set_grid()
	animPlayer02.play("descMsgFadeIn")
	animPlayer01.play("fadeIn")

func set_grid():
	boxGrid = GFuncs.make_grid(5,4)
	inst_boxes()

func inst_boxes():
	randomize()
	for i in boxGrid.size():
		for j in boxGrid[i].size():
			var randN = floor(rand_range(0,5))
			var sb = singleBox.instance()
			countPosNum += 1
			bCont.add_child(sb)
			sb.position = Vector2(bstartP.position.x + (boxOffset.x * boxGrid[i][j].y), 
								 bstartP.position.y + (boxOffset.y * boxGrid[i][j].x))
			sb.set_item_inBox(randN,countPosNum)

#	if self.selfName == 'blueGem' or self.selfName == 'redGem' or self.selfName == 'greenGem':
#		GVariables.gems += 1
#		GSignals.update_coins_gems()
#	elif self.selfName == 'coin':
#		GVariables.coins += 1
#		GSignals.update_coins_gems()
#	elif self.selfName == 'oxygen':
#		GSignals.update_oxy_value(25)

func _end_mini_game(result):
	if result == 'won':
		GSignals.inst_sounds('applause')
		if GVariables.boxItemPicked == 'blueGem' or GVariables.boxItemPicked == 'redGem' or GVariables.boxItemPicked == 'greenGem':
			GVariables.gems += GVariables.correctPicksArr.size()
			GSignals.update_coins_gems()
		elif GVariables.boxItemPicked == 'coin':
			GVariables.coins += 1
			GSignals.update_coins_gems()
		elif GVariables.boxItemPicked == 'oxygen':
			GSignals.update_oxy_value(25 * GVariables.correctPicksArr.size())

		if GVariables.correctPicksArr.size() > 1:
			descpText.text =  'You have won %s '%str(int(GVariables.correctPicksArr.size())) + str(GVariables.boxItemPicked) + 's'
		else:
			descpText.text = 'You have won %s '%str(int(GVariables.correctPicksArr.size())) + str(GVariables.boxItemPicked)
	else:
		WLtext.set('text', 'you lose')
		descpText.set('text', 'better luck next time!')
	gemCount.hide()
	textCont.set('visible', true)
	gameDescrip.set('visible', false)
	yield(get_tree().create_timer(3),'timeout')
	animPlayer01.play("fadeOutPage")


onready var timer = $Timer
onready var pickedNum = 0
#
#func move_won_items(count,itemWonName):
#	yield(get_tree().create_timer(1),'timeout')
#	for i in count:
#		yield(get_tree().create_timer(.2),'timeout')
#		tween_move(Vector2(373.352,919.239), Vector2(59.397,141.421))
#	yield(get_tree().create_timer(1),'timeout')
#	animPlayer01.play("fadeOutPage")

func tween_move(from, to):
	tween.interpolate_property(self, 'position',from, to,.3,Tween.TRANS_QUAD)
	tween.start()

func gem_item_picked(gemType):
	animPlayer02.play("descMsgFadeOut")
	GVariables.boxItemPicked = gemType
	for i in bCont.get_children():
		i.play_boxAnim()
		if GVariables.boxItemPicked == i.itemName:
			GVariables.itemChosenArr.append(i.itemPnum)
	after_choosing_item()
	goBackBtn.disabled = true
	$gemBtnCont/goBakcHome.visible = false

func after_choosing_item():
	for i in itemBtnsCont.get_children():
		i.disabled = true
	itemsSprite.hide()
	if GVariables.itemChosenArr.size() > 1:
		gameDescrip.set('text', 'Open ' + str(GVariables.itemChosenArr.size()) + ' boxes with ' + str(GVariables.boxItemPicked))
	else:
		gameDescrip.set('text', 'Open ' + str(GVariables.itemChosenArr.size()) + ' box with ' + str(GVariables.boxItemPicked))
	animPlayer02.play("descMsgFadeIn")
	gemCount.show()
	gemCount.set('text', str(GVariables.itemChosenArr.size()))

func _on_greenChosenBtn_pressed():
	gem_item_picked('greenGem')
	pickedNum = 3
	GSignals.inst_sounds('click')

func _on_blueGbtn_pressed():
	gem_item_picked('blueGem')
	pickedNum = 1
	GSignals.inst_sounds('click')

func _on_redGbtn_button_up():
	gem_item_picked('redGem')
	pickedNum = 2
	GSignals.inst_sounds('click')

func _on_starBtn_button_up():
	gem_item_picked('coin')
	pickedNum = 0
	GSignals.inst_sounds('click')

func _on_eBallBtn_button_up():
	gem_item_picked('oxygen')
	pickedNum = 4
	GSignals.inst_sounds('click')

func _on_homeBtn_pressed():
	debugger2 =  get_tree().change_scene('res://scenes/ui/startPages/readyToStartPage.tscn')

func reset_data_minigame():
	GVariables.correctPicksArr = []
	GVariables.itemChosenArr = []
	GVariables.boxItemPlayerPicked = []
	boxGrid = []

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'fadeOutPage':
		reset_data_minigame()
#		get_tree().paused = not get_tree().paused
		GSignals.stop_resume('resume')
		self.queue_free()

func _on_goBack_button_down():
	animPlayer01.play("fadeOutPage")
