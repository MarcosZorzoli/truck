extends CharacterBody3D

const SPEED = 2.5
const JUMP_VELOCITY = 5
const ROTATION_SPEED = 3
var disableMov : bool = true
var corre : bool = false
var correatras : bool = false
var der : float = 0
var jump : bool = false
var ataca : bool = false

func _ready() -> void:
	$AnimationPlayer.play("Crouch To Stand/mixamo_com")
	await get_tree().create_timer(2.5667).timeout
	$AnimationPlayer.play("Idle/mixamo_com")
	disableMov=false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !disableMov:
		if not is_on_floor():
			velocity += get_gravity() * delta
		else:
			jump = false
	# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump=true
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		var turn_input := input_dir.x
		rotation.y -= turn_input * ROTATION_SPEED * delta
		var forward_input := -input_dir.y
		var forward_dir := transform.basis.z
		
		if abs(forward_input) > 0.01:
			var	move_dir := forward_dir * forward_input
			velocity.x= -move_dir.x * SPEED
			velocity.z= -move_dir.z * SPEED	
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			corre=false
			correatras=false	
		
		corre=input_dir.y > 0.01
		correatras=input_dir.y < -0.01
		der= input_dir.x
		Animator()
		move_and_slide()


func Animator() -> void:
	if jump == true:
		$AnimationPlayer.play("Jump/mixamo_com")
	elif corre:
		$AnimationPlayer.play("Running/mixamo_com")
	elif correatras:
		$AnimationPlayer.play("Unarmed Run Back/mixamo_com")
	elif !corre and !correatras and der < -0.1:
		$AnimationPlayer.play("Left Strafe/mixamo_com")
	elif !corre and !correatras and der > 0.1:
		$AnimationPlayer.play("Right Strafe/mixamo_com")
	else:
		$AnimationPlayer.play("Idle/mixamo_com")
