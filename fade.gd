extends Panel

var fadenow = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if fadenow == true:
		set_modulate(lerp(get_modulate(), Color(0,0,0,1), 0.1))
		pass
	else:
		set_modulate(lerp(get_modulate(), Color(0,0,0,0), 0.01))



func _on_exit_door_area_nextday():	
	fadenow = true
	$fadetimer.start()


func _on_fadetimer_timeout():
	fadenow = false
