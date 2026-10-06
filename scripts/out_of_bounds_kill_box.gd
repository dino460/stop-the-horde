extends Area2D


func _on_area_entered(area: Area2D) -> void:
	var spell : Spell = area.get_parent() as Spell

	if spell != null:
		spell.queue_free()


	var enemy : Enemy = area.get_parent() as Enemy

	if self.global_position.x < 0.0 and enemy != null:
		enemy.queue_free()
