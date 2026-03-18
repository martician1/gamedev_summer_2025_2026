extends Path2D

@export var path_time = 1.0
@export var ease: Tween.EaseType
@export var transition: Tween.TransitionType
@export var path_follow_2d : PathFollow2D

func _ready() -> void:
	move_tween()

func move_tween():
	var tween = create_tween().set_loops().set_ease(ease).set_trans(transition)
	tween.tween_property(path_follow_2d, "progress_ratio", 1.0, path_time)
	tween.tween_property(path_follow_2d, "progress_ratio", 0.0, path_time)
