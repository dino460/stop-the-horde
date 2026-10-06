extends Resource

class_name Upgrade

enum UPGRADE_TYPE {
	CHAR,
	FIREBALL,
	LIGHTNING,
	BLAST,
	NOVA
}

@export var upgrade_type : UPGRADE_TYPE = UPGRADE_TYPE.CHAR

@export var upgrade_place : String = ""
@export var upgrade_value : float  = 0.0

@export var name        : String = ""
@export var description : String = ""
