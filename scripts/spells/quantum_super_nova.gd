extends Spell

class_name Nova

# @export var damage : float = 10.0
@export var pull_strength : float = 10.0

@export var audio_player : AudioStreamPlayer2D

@export var camera_shake : CameraShakeController
@export var camera_shake_strength : float = 10.0

var current_frame : int = 0

func _ready() -> void:
	camera_shake.apply_noise_shake(camera_shake_strength / 4.0)
	audio_player.pitch_scale = randf_range(0.8, 1.2)


func setup(
	p_damage : float,
	p_pull_strength : float,
	p_camera_shake : CameraShakeController
) -> void:
	damage = p_damage
	pull_strength = p_pull_strength
	camera_shake = p_camera_shake


func _process(_delta: float) -> void:
	if current_frame == 11:
		camera_shake.apply_noise_shake(camera_shake_strength)


func _on_animated_sprite_2d_animation_finished() -> void:
	self.queue_free()


func _on_animated_sprite_2d_frame_changed() -> void:
	current_frame += 1
