extends Node2D

class_name CameraShakeController


# How quickly to move through the noise
@export var NOISE_SHAKE_SPEED: float = 30.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
@export var MAX_NOISE_SHAKE_STRENGTH: float = 60.0
# Multiplier for lerping the shake strength to zero
@export var SHAKE_DECAY_RATE: float = 5.0

@export var camera : Camera2D
@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()

# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0

var shake_strength: float = 0.0

var shake_decay: float = 0.0

func _ready() -> void:
	rand.randomize()
	# Randomize the generated noise
	noise.seed = rand.randi()
	# Period affects how quickly the noise changes values
	noise.frequency = 2

func apply_noise_shake(strength : float = 10.0) -> void:
	shake_strength = min(MAX_NOISE_SHAKE_STRENGTH, strength)

func _process(delta: float) -> void:
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)

	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	camera.offset = get_noise_offset(delta)

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)
