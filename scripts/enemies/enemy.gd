extends Node2D

class_name Enemy

@export var enemy_name : String = ""

@export var balance_manager : BalanceManager

@export var animator : AnimatedSprite2D

@export var xp_reward : float = 5.0

@export var max_health : float = 10.0
@export var current_health : float

@export var has_super_armor      : bool = false
@export var super_armor_duration : float = 0.3
@export var super_armor_counter  : float = 0.0

@export var contact_damage : float = 10.0

@export var speed : float

var nova_pull_counter  : float = 0.0
@export var nova_pull_duration : float = 1.0
@export var nova_pull_strength : float = 0.0
@export var nova_pull_center : Vector2 = Vector2.ZERO

@export var a : float
@export var b : float

@export var counts_to_change_dir : int

enum MOVEMENT_PATTERN {
	LINE,
	BOUNCE,
	SINE,
	LOOP,
	RANDOM,
	NOVA_PULL
}
@export var movement_pattern : MOVEMENT_PATTERN = MOVEMENT_PATTERN.LINE
@export var movement_pattern_bak : MOVEMENT_PATTERN = MOVEMENT_PATTERN.LINE

@export var blast : PackedScene

var is_dead : bool = false

var is_cursed : bool = false
var curse_damage : float
var curse_recursion : int
var curse_camera : CameraShakeController

var t : float
var origin : Vector2

var dir : float
var dir_change_counter : int


func _ready() -> void:
	current_health = max_health

	match movement_pattern:
		MOVEMENT_PATTERN.LINE:
			pass

		MOVEMENT_PATTERN.BOUNCE:
			b = (randi_range(0, 1) - 0.5) * 2.0

		MOVEMENT_PATTERN.LOOP:
			origin = self.global_position
			var orientation : float = (randi_range(0, 1) - 0.5) * 2.0
			b *= orientation

		MOVEMENT_PATTERN.RANDOM:
			dir = (randi_range(0, floor(b)) - b / 2.0) * 2.0


func _physics_process(delta: float) -> void:
	if balance_manager.paused:
		return

	if has_super_armor:
		super_armor_counter += delta

	if super_armor_counter >= super_armor_duration:
		super_armor_counter = 0.0
		has_super_armor = false

	var next_position : Vector2 = self.global_position

	match movement_pattern:
		MOVEMENT_PATTERN.LINE:
			next_position += -transform.x * speed * delta

		MOVEMENT_PATTERN.BOUNCE:
			next_position += Vector2(-speed * delta, b * speed * delta)

		MOVEMENT_PATTERN.SINE:
			next_position += Vector2(-speed * delta, b * sin(next_position.x * a * delta))

		MOVEMENT_PATTERN.LOOP:
			var ds_dt : float = sqrt(a * a - 2.0 * a * b * cos(t) + b * b)
			t += speed * delta / ds_dt
			next_position = origin + Vector2(-(a * t - b * sin(t)), b * cos(t))

		MOVEMENT_PATTERN.RANDOM:
			dir_change_counter += 1

			if dir_change_counter > counts_to_change_dir:
				dir = (randi_range(0, floor(b)) - b / 2.0) * 2.0
				dir_change_counter = 0

			next_position += Vector2(-speed * delta, dir)

		MOVEMENT_PATTERN.NOVA_PULL:
			nova_pull_counter += delta

			next_position += next_position.direction_to(nova_pull_center) * nova_pull_strength * delta

			if nova_pull_counter >= nova_pull_duration:
				nova_pull_counter = 0.0
				movement_pattern = movement_pattern_bak

	self.global_position = next_position


func die() -> void:
	speed = 0.0
	if is_cursed and not is_dead:
		var node : Node2D = blast.instantiate()
		node.global_position = self.global_position

		var script : CrimsonBlast = node as CrimsonBlast
		script.setup(curse_damage, curse_recursion, curse_camera)

		get_tree().root.add_child(node)

	animator.play("death")
	is_dead = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	var spell : Spell = area.get_parent() as Spell

	if spell != null:
		if spell is CrimsonBlast or spell is Blastling:
			is_cursed = true
			curse_damage = spell.damage
			curse_recursion = spell.blast_recursion - 1
			curse_camera = spell.camera_shake

		if spell is Nova:
			movement_pattern_bak = movement_pattern
			movement_pattern = MOVEMENT_PATTERN.NOVA_PULL
			nova_pull_strength = spell.pull_strength
			nova_pull_center = spell.global_position

		current_health -= spell.get_damage()
		if current_health <= 0.0:
			balance_manager.xp += xp_reward * 1 + (balance_manager.level / 10.0)
			die()
		else:
			has_super_armor = true


func _on_character_animated_sprite_animation_finished() -> void:
	if is_dead:
		self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	dir = -dir
	b = -b
