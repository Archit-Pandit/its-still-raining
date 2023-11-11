extends CharacterBody2D

const SPEED = 100.0
const ACCEL = 1000.0
const FRIC = 1000.0
const JUMP_VELOCITY = -250.0

@onready var animSprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	ApplyGrav(delta)
	HandleJump()

	# Get the input inputDir and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var inputDir = Input.get_axis("ui_left", "ui_right")

	ApplyAcceleration(inputDir, delta)
	ApplyFriction(inputDir, delta)

	HandleAnim(inputDir)

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

func ApplyAcceleration(dir, delta):
	#if x is a shortcut for if x != 0 when x is a number
	if dir:
		velocity.x = move_toward(velocity.x, SPEED * dir, ACCEL * delta)

func ApplyFriction(direction, delta):
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, FRIC * delta)

func HandleAnim(dir):
	if dir:
		animSprite.flip_h = (dir < 0)
		animSprite.play("run")
	else:
		animSprite.play("idle")