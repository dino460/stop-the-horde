extends Node2D

class_name Lightning

@export var lightning : PackedScene
@export var damage : float = 10.0

@export var spread : int = 0
@export var spread_recursion : int = 0
@export var spread_delay : float = 0.3
@export var spread_delay_timer : Timer

@export var spread_range : float = 20.0

@export var audio_player : AudioStreamPlayer2D

var death_test_timer : bool = false
var death_test_animation : bool = false

func _ready() -> void:
	audio_player.pitch_scale = randf_range(0.8, 1.2)

	spread_delay_timer = Timer.new()
	spread_delay_timer.connect("timeout", _on_timer_timeout)
	spread_delay_timer.one_shot = true
	self.add_child(spread_delay_timer)
	spread_delay_timer.start(spread_delay)


func _process(_delta: float) -> void:
	if death_test_animation and death_test_timer:
		self.queue_free()


func _on_timer_timeout() -> void:
	if spread_recursion >= 0:
		for i in spread:
			var node : Node2D = lightning.instantiate()
			node.global_position = Vector2(
				self.position.x + randf_range(-spread_range * spread, spread_range * spread),
				self.position.y + randf_range(-spread_range * spread, spread_range * spread)
			)

			var script : Lightning = node as Lightning
			script.setup(lightning, damage, spread, spread_recursion - 1, spread_range)
			script.audio_player.volume_db = audio_player.volume_db * 2.0

			get_tree().root.add_child(node)
	death_test_timer = true


func setup(
	p_lightning : PackedScene,
	p_damage : float,
	p_spread : int,
	p_spread_recursion : int,
	p_spread_range : float
) -> void:
	lightning = p_lightning
	damage = p_damage
	spread = p_spread
	spread_recursion = p_spread_recursion
	spread_range = p_spread_range


func _on_animated_sprite_2d_animation_finished() -> void:
	if spread_recursion < 0:
		death_test_animation = true
