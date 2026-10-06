extends Node2D

class_name Blastling

@export var damage : float = 10.0

@export var blast_recursion : int = 1

@export var speed : float = 200.0


func setup(
	p_damage : float,
	p_blast_recursion : int
) -> void:
	damage = p_damage
	blast_recursion = p_blast_recursion
	pass


func _process(delta: float) -> void:
	self.global_position += -self.transform.y * speed * delta


func _on_animated_sprite_2d_animation_finished() -> void:
	self.queue_free()
