extends Node2D


onready var trigOn
onready var spinButton = $btnContainer/spinBtn

onready var roulettePanel = $RigidBody2D
onready var setRandNumArr = []
onready var rouletteItemsArr = ['Better luck next time', 'Try Again', 'Better luck next time', 'oxygen',
								'blueGem','redGem', 'coin', 'greenGem']
onready var prizeDegArr = [Vector2(0, 40), Vector2(40, 60), Vector2(60, 110), Vector2(110, 160),
						   Vector2(160,-150), Vector2(-150, -100), Vector2(-100, -50), Vector2(-50, 0)]

onready var spinLabel     = $textContainer/spinLabel
onready var itemCountText = $RigidBody2D/roulette
onready var itemWonMsg    = $textContainer/textMsg
onready var btnCont      =  $btnContainer
onready var oxygenCount  = $RigidBody2D/roulette/oxygen
onready var blueGcount  = $RigidBody2D/roulette/blueGem
onready var redGcount   = $RigidBody2D/roulette/redGem
onready var coinCount  = $RigidBody2D/roulette/coin
onready var greenGcount = $RigidBody2D/roulette/greenGem
onready var aaaplayer = $AnimationPlayer
onready var itCont = $itemsSpriteContainer
onready var itPos = $RigidBody2D/posContainer
onready var startEndAnimation = $startEndAnimation
onready var goBackBtn = $btnContainer/goBack
onready var gobackSprite = $goBackSprite
onready var itemWonText 
onready var itemWonCount

onready var debuggerE


func _ready():
	print(pause_mode)
	randomize()
	trigOn = false
	set_counts_items()
	spinButton.set('disabled', false)
	x_btn(true, false)
	startEndAnimation.play("insert")

func x_btn(sprite, btn):
	$goBackSprite.visible = sprite
	$btnContainer/goBack.disabled = btn

func _process(delta):
	if roulettePanel.angular_velocity < 0.1 and trigOn == true:
		for i in prizeDegArr.size():
			if roulettePanel.rotation_degrees >= prizeDegArr[i].x and roulettePanel.rotation_degrees < prizeDegArr[i].y:
				itemWonText = rouletteItemsArr[i]
				change_msg(itemWonText)
			elif roulettePanel.rotation_degrees >= 160 or roulettePanel.rotation_degrees <= -150:
				itemWonText = 'blueGem'
				change_msg(itemWonText)
			gobackSprite.hide()
		aaaplayer.play_backwards("fadeOut")
		set_process(false)

	debuggerE = delta

func _set_randnum(from, to):
	randomize()
	var randomN = rand_range(from, to)
	return randomN

func set_counts_items():
	randomize()
	var multipliedArr = [1,2,3,4,5]
	setRandNumArr = []
	while multipliedArr.size() > 0:
		var randNu = floor(rand_range(0, multipliedArr.size()))
		setRandNumArr.append(multipliedArr[randNu])
		multipliedArr.remove(randNu)
	
	for i in itemCountText.get_child_count()-1:
		itemCountText.get_child(i).set('text', str('x ',setRandNumArr[i]))

var itemName  = ''
var amountWon = 0
func change_msg(item):
	itemName = item
	if item == 'Better luck next time':
		itemWonMsg.set('text', str(item))
		startEndAnimation.play("close")
	elif item == 'Try Again':
		spin_btn_text('Spin', 50)
		spinButton.set('disabled', false)
		itemWonMsg.set('text', str(item))
	else:
		var countNumStr = itemCountText.get_node(str(item)).text
		itemWonMsg.set('text', 'You have won %s '%item + str(countNumStr))
		GVariables.itemCountTemp = int(countNumStr[-1])
		startEndAnimation.play("close")
		print(GVariables.itemCountTemp)

func update_gem_counts(itName, count):
	if itName == 'blueGem' or itName == 'redGem' or itName == 'greenGem':
		GVariables.gems += count
		GSignals.update_coins_gems()
	elif itName == 'coin':
		GVariables.coins += count
		GSignals.update_coins_gems()
	elif itName == 'oxygen':
		GSignals.update_oxy_value(25*int(count))

func sort_ascn(a, b):
	if typeof(a) != typeof(b):
		return typeof(a) < typeof(b)
		return typeof(a) < typeof(b)
	else:
		return a < b

func sort_position_asc(arr):
	arr.sort_custom(self, "sort_ascn")

func _on_spinBtn_pressed():
	if spinLabel.text == 'Spin':
		set_process(true)
		trigOn = true
		roulettePanel.set('angular_velocity', _set_randnum(15, 30))
		goBackBtn.disabled = true
		gobackSprite.hide()
		spin_btn_text('spinning', 30)
		aaaplayer.play("fadeOut")

func spin_btn_text(textStr, fontSize):
	spinLabel.text = textStr
	spinLabel.get('custom_fonts/font').size = fontSize

func _on_goBack_pressed():
	startEndAnimation.play("close1")

func _on_startEndAnimation_animation_finished(anim_name):
	if anim_name == 'close':
		GSignals.stop_resume('resume')
		update_gem_counts(itemName, GVariables.itemCountTemp)
		GVariables.itemCountTemp = 0
		self.queue_free()
	if anim_name == 'close1':
		GSignals.stop_resume('resume')
		update_gem_counts(itemName, GVariables.itemCountTemp)
		GVariables.itemCountTemp = 0
		self.queue_free()
	


func _on_Area2D_area_entered(area):
	if area.is_in_group('edge'):
		GSignals.inst_sounds('rolClick')
