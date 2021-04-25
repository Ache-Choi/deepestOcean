extends Node


func solidBlack_fade(cont, animName):
	var f = load('res://scenes/ui/fade%s.tscn'%animName).instance()
	cont.add_child(f)

func inst_sounds(soundName):
	if GVariables.soundOnOff == true:
		var s = preload('res://scenes/ui/sounds.tscn').instance()
		s.soundName = soundName
		self.add_child(s)

func make_grid(x,y):
	var arr = []
	for i in y:
		arr.append([])
		for j in x:
			var posXY = Vector2(i,j)
			arr[i].append(posXY)
	return arr 
