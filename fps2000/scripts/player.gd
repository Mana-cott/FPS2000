extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var mouse_sensitivity = 0.002
@onready var camera = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# mouse logic
func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var movement_dir = (transform.basis * Vector3(input.x, 0, input.y))
	velocity.x = movement_dir.x * SPEED
	velocity.z = movement_dir.z * SPEED

	move_and_slide()
