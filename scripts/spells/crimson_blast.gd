extends Spell

class_name CrimsonBlast

@export var blastling : PackedScene
# @export var damage : float = 10.0

@export var blast_recursion : int = 1

@export var audio_player : AudioStreamPlayer2D

@export var camera_shake : CameraShakeController
@export var camera_shake_strength : float = 5.0


func _ready() -> void:
	camera_shake.apply_noise_shake(camera_shake_strength)
	audio_player.pitch_scale = randf_range(0.8, 1.2)

	for i in 4:
		var node : Node2D = blastling.instantiate()
		node.global_position = self.global_position
		node.rotation_degrees = 45 + ((i + 1) * 90)

		var script : Blastling = node as Blastling
		script.setup(damage, blast_recursion, camera_shake)

		get_tree().root.add_child(node)


func setup(
	p_damage : float,
	p_blast_recursion : int,
	p_camera_shake : CameraShakeController
) -> void:
	damage = p_damage
	blast_recursion = p_blast_recursion
	camera_shake = p_camera_shake


func _on_animated_sprite_2d_animation_finished() -> void:
	self.queue_free()
