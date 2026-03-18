extends Control
class_name Hud

@export var hearts: HBoxContainer

@export var heart_full: Texture2D
@export var heart_empty: Texture2D 
@export var max_hearts: int:
	set(value):
		max_hearts = value
		if is_node_ready():
			update_hearts()
@export var current_hearts: int:
	set(value):
		current_hearts = value
		if is_node_ready():
			update_hearts()

@export var keys: HBoxContainer

@export var key_full: Texture2D
@export var key_empty: Texture2D 
@export var max_keys: int:
	set(value):
		max_keys = value
		if is_node_ready():
			update_keys()
@export var current_keys: int:
	set(value):
		current_keys = value
		if is_node_ready():
			update_keys()

func _ready() -> void:
	update_hearts()
	update_keys()
	
func update_hearts():
	return update_hbox(hearts, max_hearts, current_hearts, heart_empty, heart_full)

func update_keys():
	return update_hbox(keys, max_keys, max_keys - current_keys, key_full, key_empty)	

func update_hbox(box: HBoxContainer, children: int, filled_children: int, child_empty: Texture2D, child_filled: Texture2D):
	while box.get_child_count() < children:
		var new_child = TextureRect.new() 
		new_child.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		box.add_child(new_child)
	while box.get_child_count() > children:
		var child = box.get_child(box.get_child_count() - 1)
		box.remove_child(child)
		child.queue_free()
	for i in children:
		(box.get_child(i) as TextureRect).texture = child_filled if i < filled_children else child_empty
