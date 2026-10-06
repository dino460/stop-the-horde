extends PlayerClass

class_name MageClass

@export var audio_player : AudioStreamPlayer2D

@export var camera_shake : CameraShakeController


@export_group("Magic Overdrive")


@export_group("Quantum Super-Nova")
@export var nova : PackedScene
@export var nova_damage : float = 10.0
@export var nova_pull_strength : float = 10.0


@export_group("Crimson Blast")
@export var blast : PackedScene
@export var blast_damage : float = 10.0
@export var blast_recursion : int = 1


@export_group("Lightning Strike")
@export var lightning : PackedScene
@export var lightning_damage : float = 10.0

@export var lightning_spread : int = 0
@export var lightning_spread_recursion : int = 0

@export var lightning_spread_range : float = 20.0


@export_group("Fireball")
@export var fireball : PackedScene
@export var fireball_speed : float = 1.0
@export var fireball_damage : float = 10.0

@export var max_shot_angle : float = 60.0
@export var number_of_shots : int = 1

@export var penetration : int = 0

@export var split : bool = false
@export var number_of_split_shots : int = 1

@export var spread_flames : bool = false
@export var flames_lifetime : float = 1.0


func _ready() -> void:
	audio_player.pitch_scale = randf_range(0.8, 1.2)


## MAGIC OVERDRIVE
func do_skill_4() -> void:
	if not has_skill[3]:
		return

	super()


## QUANTUM SUPER-NOVA
func do_skill_3() -> void:
	if not has_skill[2]:
		return

	super()

	var node : Node2D = nova.instantiate()
	node.global_position = get_global_mouse_position()

	var script : Nova = node as Nova
	script.setup(nova_damage, nova_pull_strength)

	get_tree().root.add_child(node)


## CRIMSON Blast
func do_skill_2() -> void:
	if not has_skill[1]:
		return

	super()

	var node : Node2D = blast.instantiate()
	node.global_position = get_global_mouse_position()

	var script : CrimsonBlast = node as CrimsonBlast
	script.setup(blast_damage, blast_recursion)

	get_tree().root.add_child(node)


## LIGHTNING STRIKE
func do_skill_1() -> void:
	if not has_skill[0]:
		return

	super()

	camera_shake.apply_noise_shake()

	var node : Node2D = lightning.instantiate()
	node.global_position = get_global_mouse_position()

	var script : Lightning = node as Lightning
	script.setup(lightning, lightning_damage, lightning_spread, lightning_spread_recursion, lightning_spread_range)

	get_tree().root.add_child(node)


func attack() -> void:
	audio_player.play()
	super()

	var fireball_node : Node2D = fireball.instantiate()
	fireball_node.global_position = self.global_position

	var fireball_script : Fireball = fireball_node as Fireball
	fireball_script.setup(fireball_damage, fireball_speed, penetration, split, number_of_split_shots, spread_flames, flames_lifetime)
	fireball_script.audio_player.volume_db = fireball_script.audio_player.volume_db / number_of_shots

	get_tree().root.add_child(fireball_node)


	if number_of_shots > 1:
		var i : int = 1
		while i < number_of_shots:
			fireball_node = fireball.instantiate()
			fireball_node.global_position = self.global_position
			fireball_node.rotation_degrees = i * max_shot_angle / (number_of_shots - 1)

			fireball_script = fireball_node as Fireball
			fireball_script.setup(fireball_damage, fireball_speed, penetration, split, number_of_split_shots, spread_flames, flames_lifetime)
			fireball_script.audio_player.volume_db = fireball_script.audio_player.volume_db / number_of_shots


			get_tree().root.add_child(fireball_node)

			fireball_node = fireball.instantiate()
			fireball_node.global_position = self.global_position
			fireball_node.rotation_degrees = - i * max_shot_angle / (number_of_shots - 1)

			fireball_script = fireball_node as Fireball
			fireball_script.setup(fireball_damage, fireball_speed, penetration, split, number_of_split_shots, spread_flames, flames_lifetime)
			fireball_script.audio_player.volume_db = fireball_script.audio_player.volume_db / number_of_shots


			get_tree().root.add_child(fireball_node)

			i += 1
