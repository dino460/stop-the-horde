extends Node2D

class_name Flames

@export var lifetime : float = 1.0
@export var timer : Timer


func _ready() -> void:
	timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", _on_timer_timeout)
	timer.start(lifetime)

func _on_timer_timeout() -> void:
	queue_free()
	pass
