extends CharacterBody3D

const SPEED = 3.0
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 4.5

var speed = SPEED
var is_crouching = false
@export var mouse_sensitivity = 0.002
@onready var camera = $Camera3D
@onready var standing_col = $StandingCollisionShape3D
@onready var crouching_col = $CrouchingCollisionShape3D

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
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_crouching:
		velocity.y = JUMP_VELOCITY
		
	# Handle sprint.
	if Input.is_action_pressed("sprint") and is_on_floor() and not is_crouching:
		speed = SPRINT_SPEED
	else:
		speed = SPEED
		
	# Handle crouch.
	if Input.is_action_just_pressed("crouch"):
		is_crouching = false if is_crouching else true #toggle
		crouch(is_crouching)
		

	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var movement_dir = (transform.basis * Vector3(input.x, 0, input.y))
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	move_and_slide()
	
func crouch(is_crouching):
	if(is_crouching):
		camera.position.y = -0.5
		crouching_col.disabled = false
		standing_col.disabled = true
	else:
		camera.position.y = 0.75
		crouching_col.disabled = true
		standing_col.disabled = false
