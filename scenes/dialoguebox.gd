extends CanvasLayer

@onready var body = $Panel/body
@onready var NPCname = $Panel/speaker
@onready var scrollbar = $Panel/scrollbar
var mousemode = "free"

var charCount

var dialboxopen : bool
signal dialboxstatus(dialboxopen)

### tells player script (or any other script) whether or not the dialogue box is on screen
func _process(_delta):
	if visible == true:
		dialboxopen = true
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#mousemode = "free"
	else:
		dialboxopen = false
		#if mousemode == "free":
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			#mousemode = "capt"
	dialboxstatus.emit(dialboxopen)

### close button
func _on_close_pressed():
	visible = false

########################################### text
func showtext(x, y):
	if x == "close":
		visible = false
		return
	charCount = 0
	visible = true
	body.text = x
	NPCname.text = y
	
	### if dialogue exceeds what the box can show then the scroll bar will appear
	## scroll bar has not been coded to scroll yet 
	for i in range(0, len(x)):  
		if(x[i] != ' '):  
			charCount = charCount + 1;
	if charCount > 368:
		print("long text")
		scrollbar.visible = true



func _on_brendel_speak(x, y):
	showtext(x, y)
func _on_sir_s_speak(x, y):
	showtext(x, y)
