extends CharacterBody2D

var health = 2
var is_dead = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = $"../Player"
@onready var slime: CharacterBody2D = $"."

func _physics_process(delta: float) -> void:
	if is_dead:
		return  # Skip movement entirely
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * 20
		move_and_slide()
	
func take_damage():
	health -= 1
	animation_player.play("hurt")
	if health <= 0:
		is_dead = true
		velocity = Vector2.ZERO
		slime.z_index = -1
		animation_player.play("die")
		await animation_player.animation_finished
		queue_free()
