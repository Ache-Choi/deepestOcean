extends Node2D

onready var itemNames  = ['greenGem', 'coin', 'redGem', 
						  'blueGem', 'oxygen']
onready var imgRectPos = [Rect2(51,41,178,202), Rect2(302,49,197,184), Rect2(51,333,180,154),
						  Rect2(318,323,168,157), Rect2(570,62,150,150)]

onready var closingTimer = $Timer
onready var boxAnim1 = $boxAnim
onready var gemImg = $gem
onready var btn  = $Button

export (String) var itemName
onready var itemPnum = 0

onready var closingBoxTime

var dbugVar

func _ready():
	randomize()
	closingBoxTime = rand_range(0,1.5)

# OPEN BOX ANIMATION
func play_boxAnim():
	yield(get_tree().create_timer(closingBoxTime + 2), 'timeout')
	boxAnim1.set('playing', true)
	GSignals.inst_sounds('openHiss')
	yield(get_tree().create_timer(4), 'timeout')
	GSignals.inst_sounds('closeHiss')
	closingTimer.start()

func set_item_inBox(n,posNum):
	itemPnum = posNum
	itemName = itemNames[n]
#	if gVars.boxItemPicked == itemName:
#		gVars.itemChosenArr.append(itemPnum)
	gemImg.set('region_rect', imgRectPos[n])
	pass

# THIS IS THE BOX TOUCH OPEN
func _on_Button_button_up():
#	print(gVars.itemChosenArr, '<---------------   itemChosenArr')
	GSignals.inst_sounds('openHiss')
	boxAnim1.playing = true
	GVariables.boxItemPlayerPicked.append(itemPnum)
	if GVariables.itemChosenArr.size() == GVariables.boxItemPlayerPicked.size():

# ENDING THE MINI GAME. PLAYER HAS ALREADY USE THE CHANCES
		for i in GVariables.itemChosenArr.size():
			for j in GVariables.boxItemPlayerPicked.size():
				if GVariables.itemChosenArr[i] == GVariables.boxItemPlayerPicked[j]:
					GVariables.correctPicksArr.append(1)

# ENDING THE MINI GAME. WHEATHER THE PLAYER HAS WON OR LOST
		if GVariables.correctPicksArr.size() == GVariables.itemChosenArr.size():
			GSignals.end_mini_game('won')
		else:
			GSignals.end_mini_game('loss')
		disable_all_gem_box()
	
#	print(gVars.boxItemPlayerPicked,'<---------------   boxItemPlayerPicked')
#	print(gVars.correctPicksArr.size(),'<---------------   correct Picks from player')
#	print(gVars.correctPicksArr,'<---------------   correctPicksArr')
#	print('---------------  ---------------   ---------------  ---------------')
	btn.set('disabled', true)

	

# AFTER CHOOSING ALL BOXES WITHIN THE COUNTS
func disable_all_gem_box():
	for i in get_parent().get_children():
		if i.get_node('Button').disabled == false:
			i.get_node('Button').set('disabled', true)
#			print(i.get_node('Button').disabled)

# BOX CLOSING TIME FRAME
func _on_Timer_timeout():
	GSignals.inst_sounds('closeHiss')
	if boxAnim1.frame > 0:
		var frameNum = boxAnim1.get('frame')
		self.boxAnim1.set('frame', frameNum - 1)
		closingTimer.start()
	else:
		boxAnim1.set('playing', false)
		self.boxAnim1.set('frame', 0)
		closingTimer.stop()
		btn.set('disabled', false)

