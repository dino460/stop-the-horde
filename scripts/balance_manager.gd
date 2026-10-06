extends Node2D

class_name BalanceManager

@export var player : PlayerClass

@export var upgrades : Array[Upgrade]
@export var unlock_l : Upgrade
@export var unlock_b : Upgrade
@export var unlock_n : Upgrade

@export var spawner : Node2D

@export var enemies : Dictionary[String, PackedScene]
@export var enemy_holder : Node2D

@export var upgrade_ui : Node2D
@export var upgrade_choice : PackedScene

@export var level : int = 1
@export var xp : float = 0.0
@export var label : Label

@export var max_enemies : int = 1000
@export var spawn_rate : float = 1.5
@export var spawn_rate_counter : float = 0.0
@export var spawn_chance : Dictionary [String, float] = {
	"boss"		  : 0.0,
	"orc"		  : 0.0,
	"skeleton"	  : 0.0,
	"slime"		  : 0.0,
	"small stupid": 0.0,
}

var paused : bool = false

func _ready() -> void:
	for enemy_name in enemies:
		var enemy_node : Node2D = enemies[enemy_name].instantiate()
		var enemy_script : Enemy = enemy_node as Enemy
		enemy_script.speed = 0.0
		enemy_script.balance_manager = self
		enemy_node.global_position = Vector2(200.0, 200.0)
		enemy_node.visible = false
		enemy_holder.add_child(enemy_node)


func _process(delta: float) -> void:
	if paused:
		return

	label.text = "XP: %.1f | %.1f\nLevel: %d" % [xp, get_next_xp_goal(), level]

	spawn_rate_counter += delta

	if not enemies.is_empty() and enemy_holder.get_children().size() < max_enemies and spawn_rate_counter >= spawn_rate / (max(1.0, min(4.0, log(20 * level) / log(10)))):
		print("spawning")
		spawn_rate_counter = 0.0
		# for enemy : Enemy in enemy_holder.get_children():
		for enemy_name in enemies:

			match enemy_name:
				"boss":
					var level_mod : float = 3.0 if level % 5 == 0 else 0.8
					if randf() * max(1.0, min(3.0, log(10 * level) / log(10))) * level_mod <= spawn_chance["boss"]:
						spawn_enemy(enemies["boss"], 4.0, 0)

				"orc":
					if randf() * max(1.0, min(2.0, log(10 * level) / log(10))) <= spawn_chance["orc"]:
						spawn_enemy(enemies["orc"], 3.0)

				"skeleton":
					if randf() * max(1.0, min(2.0, log(10 * level) / log(10))) <= spawn_chance["skeleton"]:
						spawn_enemy(enemies["skeleton"], 5.0, 2)

				"slime":
					if randf() * max(1.0, min(2.0, log(10 * level) / log(10))) <= spawn_chance["slime"]:
						spawn_enemy(enemies["slime"], 3.0)

				"small stupid":
					if randf() * max(1.0, min(2.0, log(10 * level) / log(10))) <= spawn_chance["small stupid"]:
						spawn_enemy(enemies["small stupid"], 10.0, 5)

	# xp += 30 * delta

	if xp > get_next_xp_goal():
		paused = true

		level += 1
		xp = 0.0

		var upgrade : Upgrade = upgrades[randi_range(0, upgrades.size() - 1)]
		if (upgrade.upgrade_type == Upgrade.UPGRADE_TYPE.LIGHTNING and not player.has_skill[0]):
			upgrade = unlock_l
		elif (upgrade.upgrade_type == Upgrade.UPGRADE_TYPE.BLAST and not player.has_skill[1]):
			upgrade = unlock_b
		elif (upgrade.upgrade_type == Upgrade.UPGRADE_TYPE.NOVA and not player.has_skill[2]):
			upgrade = unlock_n

		var upgrade_node : Node2D = upgrade_choice.instantiate()
		var choice : UpgradeChoice = upgrade_node as UpgradeChoice
		choice.upgrade = upgrade
		choice.balance_manager = self
		choice.populate_upgrade_sheet()
		choice.player = player
		upgrade_ui.add_child(upgrade_node)
		upgrade_node.position = Vector2(-upgrade_node.get_child(0).texture.get_size().x - 10.0, 0.0)

		upgrade = upgrades[randi_range(0, upgrades.size() - 1)]
		if (upgrade.upgrade_type == Upgrade.UPGRADE_TYPE.LIGHTNING and not player.has_skill[0]):
			upgrade = unlock_l
		elif (upgrade.upgrade_type == Upgrade.UPGRADE_TYPE.BLAST and not player.has_skill[1]):
			upgrade = unlock_b
		elif (upgrade.upgrade_type == Upgrade.UPGRADE_TYPE.NOVA and not player.has_skill[2]):
			upgrade = unlock_n

		upgrade_node = upgrade_choice.instantiate()
		choice = upgrade_node as UpgradeChoice
		choice.upgrade = upgrade
		choice.balance_manager = self
		choice.populate_upgrade_sheet()
		choice.player = player
		upgrade_ui.add_child(upgrade_node)
		upgrade_node.position = Vector2.ZERO

		upgrade = upgrades[randi_range(0, upgrades.size() - 1)]
		if (upgrade.upgrade_type == Upgrade.UPGRADE_TYPE.LIGHTNING and not player.has_skill[0]):
			upgrade = unlock_l
		elif (upgrade.upgrade_type == Upgrade.UPGRADE_TYPE.BLAST and not player.has_skill[1]):
			upgrade = unlock_b
		elif (upgrade.upgrade_type == Upgrade.UPGRADE_TYPE.NOVA and not player.has_skill[2]):
			upgrade = unlock_n

		upgrade_node = upgrade_choice.instantiate()
		choice = upgrade_node as UpgradeChoice
		choice.upgrade = upgrade
		choice.balance_manager = self
		choice.populate_upgrade_sheet()
		choice.player = player
		upgrade_ui.add_child(upgrade_node)
		upgrade_node.position = Vector2(upgrade_node.get_child(0).texture.get_size().x + 10.0, 0.0)

		upgrade_ui.visible = true


func spawn_enemy(enemy : PackedScene, mod : float, min_consecutive_spawns : int = 1):
	# var max_consecutive_spawns : float = max(1.0, min(10.0, level * log(level) / log(mod)))

	for i in randi_range(min_consecutive_spawns, max(min_consecutive_spawns, mod)):
		var enemy_node : Node2D = enemy.instantiate()
		var enemy_script : Enemy = enemy_node as Enemy
		enemy_script.balance_manager = self
		enemy_script.speed *= randf_range(0.75, 1.0)
		enemy_script.max_health *= 1.0 + ((level - 1) / 100.0)
		var spawner_size : Vector2 = spawner.get_child(0).get_child(0).shape.get_rect().size
		enemy_node.global_position = Vector2(
			spawner.global_position.x,
			spawner.global_position.y + (randf_range(-spawner_size.y / 2.0, spawner_size.y / 2.0))
		)
		enemy_node.visible = true
		enemy_holder.add_child(enemy_node)


func get_next_xp_goal() -> float:
	return max(50.0, 100.0 * level * log(level))

func resume_gameplay() -> void:
	paused = false
	upgrade_ui.visible = false
	for child in upgrade_ui.get_children():
		child.queue_free()
