extends CharacterBody2D

# Reference nodes
@onready var animated_sprite = $AnimatedSprite    # change name if needed
@onready var hurtbox = $HurtBox

# Health
var health = 3

func _ready():
	# Connect the signal safely
	if hurtbox:
		hurtbox.area_entered.connect(_on_HurtBox_area_entered)
	else:
		push_error("HurtBox node not found!")

func _on_HurtBox_area_entered(area):
	# Make sure we only react to player attacks
	if area.is_in_group("player_attack"):  # optional, requires grouping player attacks
		take_damage(1)

func take_damage(amount):
	health -= amount
	print("Slime hurt! Health now:", health)
	animated_sprite.play("hurt")
	if health <= 0:
		die()

func die():
	animated_sprite.play("death")
	queue_free()   # remove slime from scene
