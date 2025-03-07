extends AnimatedSprite3D

var in_area = false
var words1 = "am knight"
var words2 = ". . . . . ."
var words3 = ". . . . . !"
var part = 0
var Sname = "Sir Squilliam"
var istalking = false
signal speak

func _input(event):
	if event.is_action_pressed("interact"):
		if in_area == true:
			if part == 2:
				speak.emit(words3, Sname)
				animation = "revive"
				play("revive")
			if part == 1:
				speak.emit(words2, Sname)
				animation = "death"
				part +=1
			if part == 0:
				speak.emit(words1, Sname)
				animation = "talk"
				play("talk")
				part +=1

##### knows if in area
func _on_sir_s_area_body_entered(body):
	if body.name == "player":
		in_area = true
func _on_sir_s_area_body_exited(body):
	if body.name == "player":
		in_area = false
		part = 0


func _on_dialoguebox_dialboxstatus(dialboxopen):
	if dialboxopen == true:
		if istalking == false:
			istalking = true
	else:
		animation = "idle"
		istalking = false
