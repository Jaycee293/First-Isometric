extends CharacterBody2D

var health = 2
var is_dead = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var slime: CharacterBody2D = $"."
@onready var player: CharacterBody2D = $"../../Player"


func _physics_process(delta: float) -> void:
	if is_dead:
		return  # Skip movement entirely
	else:
		if global_position.distance_to(player.global_position) < 70:
			var direction = global_position.direction_to(player.global_position)
			velocity = direction * 20
			var collision = move_and_collide(velocity * delta)
			if collision:
				velocity = Vector2.ZERO  # or adjust manually
	
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
