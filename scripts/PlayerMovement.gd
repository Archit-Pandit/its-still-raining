extends CharacterBody2D

const SPEED = 100.0
const ACCEL = 1000.0
const FRIC = 1000.0
const JUMP_VELOCITY = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	ApplyGrav(delta)
	HandleJump()

	# Get the input inputDir and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var inputDir = Input.get_axis("ui_left", "ui_right")

	#if x is a shortcut for if x != 0 when x is a number
	if inputDir:
		velocity.x = move_toward(velocity.x, SPEED * inputDir, ACCEL * delta)

	ApplyFriction(inputDir, delta)

	move_and_slide()

func ApplyGrav(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func HandleJump():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("ui_accept") and velocity.y <= JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2


func ApplyFriction(direction, delta):
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, FRIC * delta)
