extends Sprite3D

@onready var collision = $StaticBody3D/CollisionShape3D
var in_area : bool
signal mount(pos : Vector3)
var mounted = false

var player_pos
func _ready() -> void:
	#### get player pos
	var player = get_parent().get_node("player")
	if player:
		player_pos = player.global_position

func _process(_delta: float) -> void:
	if mounted:
		position = player_pos - Vector3(0,1,0)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "player":
		in_area = true
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "player":
		in_area = false



func _input(event):
	if event.is_action_pressed("interact"):
		if in_area:
			if not mounted:
				mounted = true
				visible = false
				collision.disabled = true
				mount.emit(position)
