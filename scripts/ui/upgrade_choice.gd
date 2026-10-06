extends Node2D

class_name UpgradeChoice

@export var upgrade : Upgrade

@export var player : PlayerClass

@export var title_lable       : Label
@export var type_lable        : Label
@export var description_lable : Label

@export var icon : Sprite2D

@export var balance_manager : BalanceManager


func populate_upgrade_sheet():
	title_lable.text = upgrade.name
	description_lable.text = upgrade.description

	match upgrade.upgrade_type:
		Upgrade.UPGRADE_TYPE.CHAR:
			type_lable.text = "MAGE"

		Upgrade.UPGRADE_TYPE.FIREBALL:
			type_lable.text = "FIREBALL"

		Upgrade.UPGRADE_TYPE.LIGHTNING:
			type_lable.text = "LIGHTNING STRIKE"

		Upgrade.UPGRADE_TYPE.BLAST:
			type_lable.text = "CRIMSON BLAST"

		Upgrade.UPGRADE_TYPE.NOVA:
			type_lable.text = "QUANTUM SUPER-NOVA"


func _on_button_pressed() -> void:
	player.apply_upgrade(upgrade)
	balance_manager.resume_gameplay()
