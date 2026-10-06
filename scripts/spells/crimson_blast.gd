extends Node2D

class_name CrimsonBlast

@export var blastling : PackedScene
@export var damage : float = 10.0

@export var blast_recursion : int = 1

@export var audio_player : AudioStreamPlayer2D


func _ready() -> void:
	audio_player.pitch_scale = randf_range(0.8, 1.2)

	for i in 4:
		var node : Node2D = blastling.instantiate()
		node.global_position = self.global_position
		node.rotation_degrees = 45 + ((i + 1) * 90)

		var script : Blastling = node as Blastling
		script.setup(damage, blast_recursion - 1)

		get_tree().root.add_child(node)


func setup(
	p_damage : float,
	p_blast_recursion : int
) -> void:
	damage = p_damage
	blast_recursion = p_blast_recursion
