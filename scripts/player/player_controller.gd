extends CharacterBody2D


@export_group("Script Setup")
@export var input_handler : InputHandler


@export_group("Combat")
@export var player_class : PlayerClass

var attack_cooldown_timer  : Timer
var skills_cooldown_timers : Array[Timer]

var current_health : float = 0.0

@export_group("Movement")
@export var max_speed : float = 250.0
@export var min_speed : float = 250.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = player_class.max_health

	attack_cooldown_timer = Timer.new()
	attack_cooldown_timer.one_shot = true
	attack_cooldown_timer.autostart = false
	attack_cooldown_timer.wait_time = 1.0 / player_class.base_attack_speed
	add_child(attack_cooldown_timer)
	attack_cooldown_timer.start()

	skills_cooldown_timers.resize(4)
	var i = 0
	while i < 4:
		skills_cooldown_timers[i] = Timer.new()
		skills_cooldown_timers[i].one_shot = true
		skills_cooldown_timers[i].autostart = false
		skills_cooldown_timers[i].wait_time = player_class.skills_base_cooldown_time[i]
		add_child(skills_cooldown_timers[i])
		skills_cooldown_timers[i].start()
		i += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var mouse_position : Vector2 = get_global_mouse_position()
	var corrected_mouse_position : Vector2 = Vector2(self.global_position.x, mouse_position.y)
	var move_direction : Vector2 = self.global_position.direction_to(corrected_mouse_position)

	# var move_direction : Vector2 = Vector2(0.0, input_handler.get_movement_this_frame()) * max_speed
	var distance_to_target : float = self.position.distance_squared_to(corrected_mouse_position)
	if distance_to_target > 5.0:
		self.move_and_collide(move_direction * max(max_speed * (distance_to_target / get_viewport().size.y), min_speed) * delta)


func _on_skill_4_pressed() -> void:
	if skills_cooldown_timers[3].time_left == 0.0:
		skills_cooldown_timers[3].start()
		player_class.do_skill_4()


func _on_skill_3_pressed() -> void:
	if skills_cooldown_timers[2].time_left == 0.0:
		skills_cooldown_timers[2].start()
		player_class.do_skill_3()


func _on_skill_2_pressed() -> void:
	if skills_cooldown_timers[1].time_left == 0.0:
		skills_cooldown_timers[1].start()
		player_class.do_skill_2()


func _on_skill_1_pressed() -> void:
	if skills_cooldown_timers[0].time_left == 0.0:
		skills_cooldown_timers[0].start()
		player_class.do_skill_1()


func _on_attack_pressed() -> void:
	if attack_cooldown_timer.time_left == 0.0:
		attack_cooldown_timer.start()
		player_class.attack()
