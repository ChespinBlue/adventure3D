extends AnimatedSprite3D

var in_area = false
var words1 = "am knight"

var part = 0
var Sname = "Sir Squilliam"
var istalking = false
signal speak

func _input(event):
	if event.is_action_pressed("interact"):
		if in_area == true:
			if part == 0:
				speak.emit(words1, Sname)
				animation = "talk"
				play("talk")
				part +=1
				return
			if part == 1:
				speak.emit("close", Sname)
				play("idle")
				part = 0
				return

##### knows if in area
func _on_sir_sarea_body_entered(body: Node3D) -> void:
	if body.name == "player":
		in_area = true
func _on_sir_sarea_body_exited(body: Node3D) -> void:
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
