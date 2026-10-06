extends Node2D

class_name PlayerClass

@export var player_class_name : String = "base class"

@export var available_skills : Array

@export var base_attack_speed : float = 0.0
@export var base_attack_damage : float = 0.0

@export var base_max_health   : float = 0.0

@export var skills_base_cooldown_time : Array[float] = [1.0, 1.0, 1.0, 1.0]

@export var animator : AnimatedSprite2D

@export var has_skill : Array[bool] = [false, false, false, false]


func attack() -> void:
	animator.play("attack")


func do_skill_4() -> void:
	if not has_skill[3]:
		return


func do_skill_3() -> void:
	if not has_skill[2]:
		return


func do_skill_2() -> void:
	if not has_skill[1]:
		return


func do_skill_1() -> void:
	if not has_skill[0]:
		return
