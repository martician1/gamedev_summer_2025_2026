extends BaseLevel

var player : PlayerController
@export var min_height: float = -100

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("players")

func _process(_delta: float) -> void:
	if player.position.y >= -min_height:
		falloff.emit()
		player.position = spawn_point.position
		player.velocity = Vector2(0, 0)
		player.state = player.State.Active
