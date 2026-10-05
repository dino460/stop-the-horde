extends Resource

class_name PlayerClass

@export var player_class_name : String = "base class"

@export var available_skills : Array

@export var base_attack_speed : float = 0.0
@export var base_max_health   : float = 0.0

@export var skills_base_cooldown_time : Array[float] = [0.0, 0.0, 0.0, 0.0]
