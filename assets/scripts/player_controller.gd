extends CharacterBody2D
class_name PlayerController

signal enemy_hit(player: PlayerController)

@export var speed := 100.0
@export var jump_speed := 300.0
@export var max_jump_combo := 2
@export var repel_impulse := Vector2(600, 300)
@export var plunge_charge_time := 0.5
@export var slowdown_speed := 50.0
@export var attack_radius := 30.0
@export var particles : GPUParticles2D
@export var plunge_attack_speed := 500.0

enum State { Active, Hurt, PlungeCharge, PlungeAttack }

var state: State = State.Active
var jump_combo = 0
	
func _ready() -> void:
	await get_tree().process_frame
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.player_hit.connect(_on_player_hit)

func hit_enemies_within_radius(r: float):
	var space_state := get_world_2d().direct_space_state
	var shape = CircleShape2D.new()
	shape.radius = r
	
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = global_transform
	query.collision_mask = 1 << 1 # enemy mask
	for enemy in space_state.intersect_shape(query):
		enemy_hit.emit(enemy["collider"] as Enemy)

func _on_player_hit(enemy: Enemy):
	if state == State.PlungeCharge || state == State.PlungeAttack:
		return
	state = State.Hurt
	velocity.x = repel_impulse.x * sign(global_position.x - enemy.global_position.x)
	velocity.y = -repel_impulse.y

func _physics_process(delta: float) -> void:
	match state:
		State.Hurt:
			velocity += get_gravity() * delta
			velocity.x = move_toward(velocity.x, 0, slowdown_speed)
			move_and_slide()
			if is_on_floor():
				state = State.Active
		State.PlungeAttack:
			velocity.x = 0
			velocity.y = plunge_attack_speed
			move_and_slide()
			hit_enemies_within_radius(attack_radius)
			if is_on_floor():
				particles.emitting = true
				state = State.Active
		State.PlungeCharge:
			velocity.x = 0
			velocity.y = 0
			move_and_slide()
		State.Active:
			velocity += get_gravity() * delta

			if not is_on_floor() and Input.is_action_just_pressed("plunge"):
				state = State.PlungeCharge
				velocity.x = 0
				velocity.y = 0
				await get_tree().create_timer(plunge_charge_time).timeout
				state = State.PlungeAttack
			else:
				if Input.is_action_just_pressed("jump") and jump_combo < max_jump_combo:
					velocity.y = -jump_speed
					jump_combo += 1
		
				var direction = Input.get_axis("walk_left", "walk_right")
				if direction:
					velocity.x = direction * speed
				else:
					velocity.x = move_toward(velocity.x, 0, slowdown_speed)
				move_and_slide()
	
	if is_on_floor():
		jump_combo = 0
