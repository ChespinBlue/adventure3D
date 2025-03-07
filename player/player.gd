extends CharacterBody3D

var rng = RandomNumberGenerator.new()
const spawnPosition = Vector3(0.0, 5.0, 0.0)
signal died
const SPEED = 9.0
var SPEEh = 0.0
const JUMP_VELOCITY = 5.0
var pdialboxopen = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

######### exit
func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
#####################@@@@@@@@@@@@@@###connect other stuff and camera
@onready var neck := $neck
@onready var camera := $neck/Camera3D
#capture mouse if button clicked and rotate neck
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		pass
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion:
		#if pdialboxopen == false:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			neck.rotate_y(-event.relative.x * 0.005)
			camera.rotate_x(-event.relative.y * 0.005)
			#stop from breaking neck
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
#################@@@@@@@@@@@@$$$$$$$$$#######################

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

################### preset
func _physics_process(delta):
	 
	if position.y < -30:
		death()
	
	#####restart
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	#camera.rotate_x(-4.0*delta)
	#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#### have to define this before cheking if dialoguebox open so computer wont get confused
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	### cant move when dialoge box is open
	if pdialboxopen == true:
		input_dir = Input.get_vector("fake", "fake", "fake", "fake")
	else:
		input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, 0.1)
		velocity.z = lerp(velocity.z, direction.z * SPEED, 0.1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/10)
		velocity.z = move_toward(velocity.z, 0, SPEED/10)

	move_and_slide()

func death():
	died.emit()
	position = spawnPosition


func _on_dialoguebox_dialboxstatus(dialboxopen):
	if dialboxopen == true:
		pdialboxopen = true
	else:
		pdialboxopen = false
