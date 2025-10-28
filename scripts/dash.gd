extends Node2D

const DASH_DELAY = 0.4
@onready var duration_timer: Timer = $DurationTimer
@onready var ghost_timer: Timer = $GhostTimer
var ghost_scene = preload("res://scenes/DashGhost.tscn")
var sprite



var can_dash: bool = true
var dash_direction: Vector2 = Vector2.ZERO

func start_dash(player: Node2D, direction: Vector2, duration: float) -> void:
	if not can_dash:
		return
	can_dash = false               # LOCK dash immediately
	self.sprite = sprite
	dash_direction = direction.normalized() if direction != Vector2.ZERO else Vector2.ZERO
	duration_timer.wait_time = duration
	duration_timer.start()
	
	ghost_timer.start()
	instance_ghost()

func instance_ghost():
	var ghost: Sprite2D = ghost_scene.instantiate()
	get_parent().get_parent().add_child(ghost)
	ghost.global_position = global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	

func is_dashing() -> bool:
	return !duration_timer.is_stopped()

func end_dash() -> void:
	dash_direction = Vector2.ZERO
	# Start cooldown timer
	ghost_timer.stop()
	await get_tree().create_timer(DASH_DELAY).timeout
	can_dash = true

func _on_duration_timer_timeout() -> void:
	end_dash()


func _on_ghost_timer_timeout() -> void:
	instance_ghost()
