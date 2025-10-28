extends Sprite2D

@onready var tween = get_tree().create_tween()

func _ready() -> void:
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"modulate:a",0.0,3)
	tween.connect("finished", Callable(self, "_on_tween_finished"))
	
func _on_tween_finished():
	queue_free()
	
