extends Spell

class_name Fireball

@export var fireball : PackedScene
@export var speed : float = 1.0
# @export var damage : float = 10.0

@export var penetration : int = 0

@export var split_recursion : int = 0
@export var max_split_shot_angle : float = 15.0
@export var number_of_split_shots : int = 2

@export var spread_flames : bool = false
@export var flames : PackedScene
@export var flame_interval : float = 2.0
@export var flame_interval_counter : float = 0.0
@export var flames_lifetime : float = 1.0

@export var audio_player : AudioStreamPlayer2D


func _ready() -> void:
	audio_player.pitch_scale = randf_range(0.8, 1.2)


func _physics_process(delta: float) -> void:
	var applied_speed : Vector2 = Vector2(delta * speed, 0.0)
	self.global_position += applied_speed.rotated(self.global_rotation)

	if spread_flames:
		if flame_interval_counter >= flame_interval * 1.1 / speed:
			flame_interval_counter = 0.0

			var flame_node : Node2D = flames.instantiate()
			flame_node.global_position = self.global_position

			var flames_script : Flames = flame_node as Flames
			flames_script.lifetime = flames_lifetime

			get_tree().root.add_child(flame_node)

		flame_interval_counter += delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		if split_recursion:
			var i : int = 1
			while i < number_of_split_shots:
				var secondary_fireball_node : Node2D = fireball.instantiate()
				secondary_fireball_node.global_position = self.global_position
				secondary_fireball_node.rotation_degrees = i * max_split_shot_angle / (number_of_split_shots - 1)

				var fireball_script : Fireball = secondary_fireball_node as Fireball
				fireball_script.setup(fireball, damage, speed, penetration, split_recursion - 1, number_of_split_shots, spread_flames, flames_lifetime)


				get_tree().root.add_child(secondary_fireball_node)

				secondary_fireball_node = fireball.instantiate()
				secondary_fireball_node.global_position = self.global_position
				secondary_fireball_node.rotation_degrees = - i * max_split_shot_angle / (number_of_split_shots - 1)

				fireball_script = secondary_fireball_node as Fireball
				fireball_script.setup(fireball, damage, speed, penetration, split_recursion - 1, number_of_split_shots, spread_flames, flames_lifetime)


				get_tree().root.add_child(secondary_fireball_node)

				i += 1
		if penetration <= 0:

			self.queue_free()
		else:
			penetration -= 1

	pass # Replace with function body.


func setup(
	p_fireball : PackedScene,
	p_damage : float,
	p_speed : float,
	p_penetration : int,
	p_split_recursion : int,
	p_number_of_split_shots : int,
	p_spread_flames : bool,
	p_flames_lifetime : float
) -> void:
	fireball = p_fireball
	damage = p_damage
	speed = p_speed
	penetration = p_penetration
	split_recursion = p_split_recursion
	number_of_split_shots = p_number_of_split_shots
	spread_flames = p_spread_flames
	flames_lifetime = p_flames_lifetime
