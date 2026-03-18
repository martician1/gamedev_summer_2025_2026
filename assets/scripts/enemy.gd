extends CharacterBody2D
class_name Enemy

signal player_hit(enemy: Enemy)

enum State { ALIVE, DYING }

var state := State.ALIVE

@export var damage := 1
@export var detection_range := 100.0
@export var charge_speed := 20.0
@export var jump_speed := 200.0
@export var min_edge_distance := 10.0
@export var die_time := 1.0
@export var slowdown_speed := 20.0
@export var particles: GPUParticles2D

@export var attack_cooldown := 0.1
var is_attack_cooldown_active := false

var player: PlayerController = null

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("players")
	
func die():
	state = State.DYING
	particles.emitting = true
	collision_layer = 1 << 2 # change collision layer to "dying enemy"
	collision_mask &= ~1 # remove player from collision mask 
	await get_tree().create_timer(die_time).timeout
	queue_free()

func is_player_visible(ray: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + ray,
	)
	query.exclude = [self]
	return space_state.intersect_ray(query).get("collider") is PlayerController

func get_ground(position: Vector2) -> Object:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(
		position,
		position + Vector2(0.0, 100.0),
		(1 << 8) # mask ground
	)
	return space_state.intersect_ray(query).get("collider")

func is_near_edge(direction: float) -> bool:
	var in_front = global_position
	in_front.x += min_edge_distance * direction
	return get_ground(global_position) != get_ground(in_front)

func _physics_process(delta: float) -> void:	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor() and is_player_visible(Vector2(0.0, -detection_range)):
		velocity.y = -jump_speed
		velocity.x = 0
	elif is_on_floor() and player and player.global_position.distance_to(global_position) <= detection_range:
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = charge_speed * direction
		if is_near_edge(direction):
			velocity.x = move_toward(velocity.x, 0, slowdown_speed)			
	else:
		velocity.x = move_toward(velocity.x, 0, slowdown_speed)

	move_and_slide()
	
	if state == State.ALIVE and not is_attack_cooldown_active:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision and collision.get_collider() is PlayerController:
				attack()
				break

func attack():
	if player:
		player_hit.emit(self)
		is_attack_cooldown_active = true
		await get_tree().create_timer(attack_cooldown).timeout
		is_attack_cooldown_active = false
