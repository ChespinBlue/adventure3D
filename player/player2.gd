extends CharacterBody3D

var rng = RandomNumberGenerator.new()
const spawnPosition = Vector3(1.0, 1.0, 0.0)
signal died
const SPEED = 9.0
const JUMP_VELOCITY = 4.5
signal disp
var lefpres = false
var rigpres = false
var uppres = false
var dowpres = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

######### exit
func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("test"):
		disp.emit()
		
	if event.is_action_pressed("player2left"):
		lefpres = true
	if event.is_action_released("player2left"):
		lefpres = false
	if event.is_action_pressed("player2right"):
		rigpres = true
	if event.is_action_released("player2right"):
		rigpres = false
	if event.is_action_pressed("player2up"):
		uppres = true
	if event.is_action_released("player2up"):
		uppres = false
	if event.is_action_pressed("player2down"):
		dowpres = true
	if event.is_action_released("player2down"):
		dowpres = false
		
	if event.is_action_pressed("player2shoot"):
		shoot()
	
	if Input.is_action_just_pressed("player2five"):
		if gun.visible == false:
			gun.visible = true
		else:
			gun.visible = false
#####################@@@@@@@@@@@@@@###connect other stuff and camera
@onready var neck := $neck
@onready var camera := $neck/Camera3D
#capture mouse if button clicked and rotate neck
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseMotion:
		neck.rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		#stop from breaking neck
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
#################@@@@@@@@@@@@$$$$$$$$$#######################

################### preset
func _physics_process(delta):
	 
	if position.y < -30:
		death()
	
	#####restart
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
	if lefpres == true:
		neck.rotate_y(4.0*delta)
	if rigpres == true:
		neck.rotate_y(-4.0*delta)
	if uppres == true:
		camera.rotate_x(4.0*delta)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	if dowpres == true:
		camera.rotate_x(-4.0*delta)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_dir = Input.get_vector("player2leftwalk", "player2rightwalk", "player2forwardwalk", "player2backwalk")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _process(_delta):
	Glight.light_energy = lerp(Glight.light_energy, 0.0, 0.4)

@onready var gun = $neck/Camera3D/Sketchfab_Scene
@onready var bullet = preload("res://gun/bullet.tscn")

@onready var Glight = $neck/Camera3D/Sketchfab_Scene/gunlight
@onready var GlightT = $neck/Camera3D/Sketchfab_Scene/gunlight/gunlighttimer
@onready var GlightS = $neck/Camera3D/Sketchfab_Scene/gunlight/Sprite3D
var GFspriteH = 0
var GFspriteV = 0

######### shooting	
func shoot():
	if gun.visible == true:
		var Binstance = bullet.instantiate()
		Binstance.position = gun.global_position
		Binstance.transform.basis = gun.global_transform.basis * -1
		get_parent().add_child(Binstance)
		Glight.visible = true
		Glight.light_energy = 2
		GlightT.start()
		##### randomly changes flash at end of gun
		GFspriteH = rng.randi_range(0, 1)
		GFspriteV = rng.randi_range(0, 1)
		if GFspriteH == 0:
			GlightS.flip_h = true
		else:
			GlightS.flip_h = false
		if GFspriteV == 0:
			GlightS.flip_v = true
		else:
			GlightS.flip_v = false

func _on_gunlighttimer_timeout():
	Glight.visible = false



signal hitsignal
func hit():
	hitsignal.emit()

func death():
	died.emit()
	position = spawnPosition


func _on_health_p_2_health_deplete():
	death()


func _on_player_died():
	position.y += 0.5


func _on_highfiving_nextlevel():
	position.y += 80
