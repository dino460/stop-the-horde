extends Area2D



func _on_area_exited(area: Area2D) -> void:
	area.get_parent().queue_free()
	# area.owner.queue_free()



func _on_body_exited(body: Node2D) -> void:
	body.queue_free()
