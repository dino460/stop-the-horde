extends Node2D

class_name Nova

@export var damage : float = 10.0
@export var pull_strength : float = 10.0

@export var audio_player : AudioStreamPlayer2D


func _ready() -> void:
	audio_player.pitch_scale = randf_range(0.8, 1.2)


func setup(
	p_damage : float,
	p_pull_strength : float
) -> void:
	damage = p_damage
	pull_strength = p_pull_strength
