extends Node2D

const DASH_DELAY = 0.4
@onready var duration_timer: Timer = $DurationTimer

var can_dash: bool = true
var dash_direction: Vector2 = Vector2.ZERO

func start_dash(direction: Vector2, duration: float) -> void:
	if not can_dash:
		return
	can_dash = false               # LOCK dash immediately
	dash_direction = direction.normalized() if direction != Vector2.ZERO else Vector2.ZERO
	duration_timer.wait_time = duration
	duration_timer.start()

func is_dashing() -> bool:
	return !duration_timer.is_stopped()

func end_dash() -> void:
	dash_direction = Vector2.ZERO
	# Start cooldown timer
	await get_tree().create_timer(DASH_DELAY).timeout
	can_dash = true

func _on_duration_timer_timeout() -> void:
	end_dash()
