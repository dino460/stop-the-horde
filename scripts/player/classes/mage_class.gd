extends PlayerClass

class_name MageClass

@export var audio_player : AudioStreamPlayer2D

@export var camera_shake : CameraShakeController
@export var fireball_camera_shake_strength : float = 2.0


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

@export var split_recursion : int = 0
@export var number_of_split_shots : int = 1

@export var spread_flames : bool = false
@export var flames_lifetime : float = 1.0


func _ready() -> void:
	audio_player.pitch_scale = randf_range(0.8, 1.2)


func apply_upgrade(upgrade : Upgrade):
	super(upgrade)

	print(upgrade.name)
	print(upgrade.upgrade_type)
	print(upgrade.upgrade_place)

	match upgrade.upgrade_type:
		Upgrade.UPGRADE_TYPE.CHAR:
			match upgrade.upgrade_place:
				"health":
					self.max_health += upgrade.upgrade_value
				"atk_speed":
					self.base_attack_speed += upgrade.upgrade_value

		Upgrade.UPGRADE_TYPE.FIREBALL:
			print("here")
			match upgrade.upgrade_place:
				"shots":
					print("shots")
					self.number_of_shots += floor(upgrade.upgrade_value)
				"damage":
					print("dmg")
					self.fireball_damage += upgrade.upgrade_value
				"penetration":
					print("pen")
					self.penetration += floor(upgrade.upgrade_value)
				"split":
					print("split")
					self.number_of_split_shots += floor(upgrade.upgrade_value)
				"split recursion":
					print("split rec")
					self.split_recursion += floor(upgrade.upgrade_value)

		Upgrade.UPGRADE_TYPE.LIGHTNING:
			match upgrade.upgrade_place:
				"damage":
					self.lightning_damage += upgrade.upgrade_value
				"split":
					self.lightning_spread += floor(upgrade.upgrade_value)
				"split recursion":
					self.lightning_spread_recursion += floor(upgrade.upgrade_value)
				"unlock":
					self.has_skill[0] = true

		Upgrade.UPGRADE_TYPE.BLAST:
			match upgrade.upgrade_place:
				"damage":
					self.blast_damage += upgrade.upgrade_value
				"recursion":
					self.blast_recursion += floor(upgrade.upgrade_value)
				"unlock":
					self.has_skill[1] = true

		Upgrade.UPGRADE_TYPE.NOVA:
			match upgrade.upgrade_place:
				"damage":
					self.nova_damage += upgrade.upgrade_value
				"pull":
					self.nova_pull_strength += upgrade.upgrade_value
				"unlock":
					self.has_skill[2] = true


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
	script.setup(nova_damage, nova_pull_strength, camera_shake)

	get_tree().root.add_child(node)


## CRIMSON Blast
func do_skill_2() -> void:
	if not has_skill[1]:
		return

	super()

	var node : Node2D = blast.instantiate()
	node.global_position = get_global_mouse_position()

	var script : CrimsonBlast = node as CrimsonBlast
	script.setup(blast_damage, blast_recursion, camera_shake)

	get_tree().root.add_child(node)


## LIGHTNING STRIKE
func do_skill_1() -> void:
	if not has_skill[0]:
		return

	super()

	# camera_shake.apply_noise_shake(10.0 * pow(lightning_spread, lightning_spread_recursion))

	var node : Node2D = lightning.instantiate()
	node.global_position = get_global_mouse_position()

	var script : Lightning = node as Lightning
	script.setup(lightning, lightning_damage, lightning_spread, lightning_spread_recursion, lightning_spread_range, camera_shake)

	get_tree().root.add_child(node)


func attack() -> void:
	print(number_of_split_shots)
	camera_shake.apply_noise_shake(fireball_camera_shake_strength)
	audio_player.play()
	super()

	var fireball_node : Node2D = fireball.instantiate()
	fireball_node.global_position = self.global_position

	var fireball_script : Fireball = fireball_node as Fireball
	fireball_script.setup(fireball, fireball_damage, fireball_speed, penetration, split_recursion, number_of_split_shots, spread_flames, flames_lifetime)
	fireball_script.audio_player.volume_db = fireball_script.audio_player.volume_db / number_of_shots

	get_tree().root.add_child(fireball_node)


	if number_of_shots > 1:
		var i : int = 1
		while i < number_of_shots:
			fireball_node = fireball.instantiate()
			fireball_node.global_position = self.global_position
			fireball_node.rotation_degrees = i * max_shot_angle / (number_of_shots - 1)

			fireball_script = fireball_node as Fireball
			fireball_script.setup(fireball, fireball_damage, fireball_speed, penetration, split_recursion, number_of_split_shots, spread_flames, flames_lifetime)
			fireball_script.audio_player.volume_db = fireball_script.audio_player.volume_db / number_of_shots


			get_tree().root.add_child(fireball_node)

			fireball_node = fireball.instantiate()
			fireball_node.global_position = self.global_position
			fireball_node.rotation_degrees = - i * max_shot_angle / (number_of_shots - 1)

			fireball_script = fireball_node as Fireball
			fireball_script.setup(fireball, fireball_damage, fireball_speed, penetration, split_recursion, number_of_split_shots, spread_flames, flames_lifetime)
			fireball_script.audio_player.volume_db = fireball_script.audio_player.volume_db / number_of_shots


			get_tree().root.add_child(fireball_node)

			i += 1
