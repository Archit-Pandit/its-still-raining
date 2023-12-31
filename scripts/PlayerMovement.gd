extends CharacterBody2D

@export var movementData : MovementData

# Node References
@onready var animSprite = $AnimatedSprite2D
@onready var coyoteJumpTimer = $CoyoteJump

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	ApplyGrav(delta)
	HandleJump()

	var inputDir = Input.get_axis("walk_left", "walk_right")

	ApplyAcceleration(inputDir, delta)
	ApplyFriction(inputDir, delta)

	HandleAnim(inputDir)
	HandleMoveNSlide()
	

func ApplyGrav(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func HandleJump():
	if is_on_floor() or coyoteJumpTimer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = movementData.jumpVelocity
	if not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y <= movementData.jumpVelocity / 2:
			velocity.y = movementData.jumpVelocity / 2

func ApplyAcceleration(dir, delta):
	#if x is a shortcut for if x != 0 when x is a number
	if dir:
		velocity.x = move_toward(velocity.x, movementData.speed * dir, movementData.acceleration * delta)

func ApplyFriction(direction, delta):
	if direction == 0:
		velocity.x = move_toward(velocity.x, 0, movementData.friction * delta)

func HandleAnim(dir):
	if dir:
		animSprite.flip_h = (dir < 0)
		animSprite.play("run")
	else:
		animSprite.play("idle")

func HandleMoveNSlide():
	var wasOnFloor = is_on_floor()

	#CharacterBody2D function
	move_and_slide()

	var isOffFloor = wasOnFloor and not is_on_floor() and velocity.y >= 0

	if isOffFloor:
		coyoteJumpTimer.start()