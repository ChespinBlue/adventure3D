extends CanvasLayer

@onready var hb = $player1Hb
var H = 100.0
signal p1healthDeplete


func _process(_delta):
	#H-=0.1
	
	hb.value = lerp(hb.value, H,0.4)
	
	if H <= 0.0:
		p1healthDeplete.emit()
		H = 100.0
	if H > 100.0:
		H = 100.0
