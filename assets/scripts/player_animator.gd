extends AnimatedSprite2D

@export var player_controller: PlayerController
@export var effect_animator: AnimationPlayer

func _process(_delta: float) -> void:
	if player_controller.state == PlayerController.State.Hurt:
		play("hurt")
		effect_animator.play("flash")
	elif player_controller.state == PlayerController.State.PlungeCharge:
		effect_animator.play("plunge_charge")
	else:
		if player_controller.velocity.x > 0:
			flip_h = false
		elif player_controller.velocity.x < 0:
			flip_h = true
		
		if player_controller.is_on_floor() and player_controller.velocity.x == 0:
			play("idle")
		elif player_controller.is_on_floor():
			play("walk")
		else:
			play("jump")
