extends CharacterBody2D


@export_group("Script Setup")
@export var input_handler : InputHandler


@export_group("Combat")
@export var player_class : PlayerClass

var attack_cooldown_timer  : Timer
var skills_cooldown_timers : Array[Timer]


@export_group("Movement")
@export_range(1.0, 50.0, 0.1) var movement_speed : float = 5.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_cooldown_timer = Timer.new()
	attack_cooldown_timer.one_shot = true
	attack_cooldown_timer.autostart = false
	attack_cooldown_timer.wait_time = 1.0 / player_class.base_attack_speed
	add_child(attack_cooldown_timer)
	attack_cooldown_timer.start()

	skills_cooldown_timers.resize(4)
	var i = 1
	while i < 0:
		skills_cooldown_timers[i] = Timer.new()
		skills_cooldown_timers[i].one_shot = true
		skills_cooldown_timers[i].autostart = false
		skills_cooldown_timers[i].wait_time = player_class.skills_base_cooldown_time[i]
		add_child(skills_cooldown_timers[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var move_direction : Vector2 = Vector2(0.0, input_handler.get_movement_this_frame()) * movement_speed

	self.move_and_collide(move_direction)


func _on_skill_4_pressed() -> void:
	print("skill 4")


func _on_skill_3_pressed() -> void:
	print("skill 3")


func _on_skill_2_pressed() -> void:
	print("skill 2")


func _on_skill_1_pressed() -> void:
	print("skill 1")


func _on_attack_pressed() -> void:
	if attack_cooldown_timer.time_left == 0.0:
		attack_cooldown_timer.start()
		print("attack as ", player_class.player_class_name)
