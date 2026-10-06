extends Node

class_name InputHandler


signal attack_pressed
signal skill_1_pressed
signal skill_2_pressed
signal skill_3_pressed
signal skill_4_pressed


func _process(_delta: float) -> void:
	if Input.is_action_pressed("attack"):
		attack_pressed.emit()

	if Input.is_action_pressed("skill_1"):
		skill_1_pressed.emit()

	if Input.is_action_pressed("skill_2"):
		skill_2_pressed.emit()

	if Input.is_action_pressed("skill_3"):
		skill_3_pressed.emit()

	if Input.is_action_pressed("skill_4"):
		skill_4_pressed.emit()


func get_movement_this_frame() -> float:
	var movement_direction : float = Input.get_axis("move_up", "move_down")
	return movement_direction
