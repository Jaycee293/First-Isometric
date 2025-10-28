extends CharacterBody2D

# --------------------------
# NODE REFERENCES
# --------------------------
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack: Sprite2D = $Attack
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dash: Node2D = $Dash

# --------------------------
# PLAYER STATE
# --------------------------
var last_facing: String = "down"
var hp = 100.0
var is_alive = true
signal hp_zero

# --------------------------
# CONSTANTS
# --------------------------
const SPEED = 100.0
const DASH_SPEED = 500.0
const DASH_DUR = 0.1
const DMG_RATE = 20.0

# --------------------------
# PHYSICS PROCESS
# --------------------------
func _physics_process(delta: float) -> void:
	if not is_alive:
		return

	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	# DASH INPUT
	if Input.is_action_just_pressed("dash") and dash.can_dash:
		dash.start_dash(self, direction, DASH_DUR)

	# APPLY VELOCITY
	if dash.is_dashing():
		velocity = dash.dash_direction * DASH_SPEED
	else:
		velocity = direction.normalized() * SPEED if direction != Vector2.ZERO else Vector2.ZERO

	# ANIMATION
	set_animation(direction)

	# MOVE PLAYER
	move_and_slide()

	# ATTACK INPUT
	if Input.is_action_just_pressed("attack_down"):
		_do_attack()
	if Input.is_action_just_pressed("attack_up"):
		_do_attack()
	if Input.is_action_just_pressed("attack_left"):
		_do_attack()
	if Input.is_action_just_pressed("attack_right"):
		_do_attack()

	# DAMAGE CHECK
	var overlapping_enem = %MyHurtBox.get_overlapping_bodies()
	if overlapping_enem.size() > 0 and is_alive and not dash.is_dashing():
		hp -= DMG_RATE * overlapping_enem.size() * delta
		%ProgressBar.value = hp

		# Hurt animation
		animated_sprite_2d.hide()
		attack.show()
		animation_player.play("front_hurt")
		await animation_player.animation_finished
		attack.hide()
		animated_sprite_2d.show()

		if hp <= 0.0:
			die()
			hp_zero.emit()

# --------------------------
# ANIMATION HANDLER
# --------------------------
func set_animation(direction: Vector2):
	if direction != Vector2.ZERO:
		if direction.x != 0:
			animated_sprite_2d.play("side_walk")
			animated_sprite_2d.flip_h = direction.x < 0
			last_facing = "left" if direction.x < 0 else "right"
		elif direction.y != 0:
			animated_sprite_2d.play("back_walk" if direction.y < 0 else "front_walk")
			last_facing = "up" if direction.y < 0 else "down"
	else:
		match last_facing:
			"down":
				animated_sprite_2d.play("front_idle")
			"up":
				animated_sprite_2d.play("back_idle")
			"left":
				animated_sprite_2d.flip_h = true
				animated_sprite_2d.play("side_idle")
			"right":
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.play("side_idle")

# --------------------------
# ATTACK LOGIC
# --------------------------
func _do_attack():
	animated_sprite_2d.hide()
	attack.show()

	if Input.is_action_just_pressed("attack_down"):
		animation_player.play("front_attack")
		last_facing = "down" 
	elif Input.is_action_just_pressed("attack_up"):
		animation_player.play("back_attack")
		last_facing = "up" 
	elif Input.is_action_just_pressed("attack_left"):
		animation_player.play("left_attack")
		last_facing = "left" 
	elif Input.is_action_just_pressed("attack_right"):
		animation_player.play("right_attack")
		last_facing = "right" 

	await animation_player.animation_finished
	attack.hide()
	animated_sprite_2d.show()

# --------------------------
# DEATH LOGIC
# --------------------------
func die():
	is_alive = false
	animated_sprite_2d.hide()
	attack.show()
	animation_player.play("death")
	await animation_player.animation_finished
	get_tree().paused = true

# --------------------------
# HP ZERO SIGNAL
# --------------------------
func _on_hp_zero() -> void:
	%"Game over".visible = true
