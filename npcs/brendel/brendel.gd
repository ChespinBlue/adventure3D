extends AnimatedSprite3D

var in_area = false
var words = "hi                                                                              (you feel vaguely threatened)"
var part = 0
var istalking = false
signal speak

func _input(event):
	if event.is_action_pressed("interact"):
		if in_area == true:
			if part == 0:
				speak.emit(words, "brendel")
				part += 1
				return
			if part == 1:
				speak.emit("close", "none")
				part = 0
				return

##### knows if in area
func _on_brendel_area_body_entered(body):
	if body.name == "player":
		in_area = true
		
func _on_brendel_area_body_exited(body):
	if body.name == "player":
		in_area = false




func _on_dialoguebox_dialboxstatus(dialboxopen):
	if dialboxopen == true:
		if istalking == false:
			animation = "talk"
			istalking = true
	else:
		animation = "idle"
		istalking = false
		
