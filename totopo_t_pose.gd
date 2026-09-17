extends CharacterBody3D
@onready var raycast1 = $RayCast3D1
@onready var raycast2 = $RayCast3D2
@onready var raycast3 = $RayCast3D3
@onready var PlayerRoot = $"."
@onready var PlayerModel = $"."

var gravity 
const SPEED = 3
const JUMP_VELOCITY = 5
const ROTATION_SPEED = 4
var disableMov : bool = true
var corre : bool = false
var correatras : bool = false
var der : float = 0
var jump : bool = false
var anim_is_on_ledge : bool = false
var onledge : bool = false

func _ready() -> void:
	gravity = get_gravity()
	$AnimationPlayer.play("Crouch To Stand/mixamo_com")
	await get_tree().create_timer(2.5667).timeout
	$AnimationPlayer.play("Idle/mixamo_com")
	disableMov=false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !disableMov:
		if not is_on_floor():
			velocity += gravity * delta
		else:
			jump = false
		raycast_detect_ledge()
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
	elif anim_is_on_ledge:
		$AnimationPlayer.play("Climbing/mixamo_com")
		await get_tree().create_timer(4.3).timeout
		$AnimationPlayer.play("Idle/mixamo_com")
	else:
		$AnimationPlayer.play("Idle/mixamo_com")
		
func raycast_detect_ledge()-> void:
	if !raycast1.is_colliding() and raycast2.is_colliding():
		onledge=true
		raycast3.enabled = true
	if onledge:
		$Skeleton3D/mesh_0.set_as_top_level(true)
		anim_is_on_ledge=true
		disableMov=true
		corre=false
		correatras=false
		jump=false
		Animator()
	else:
		disableMov=false
		anim_is_on_ledge=false
		
func teleport () -> void:
	self.global_transform.origin = raycast3.get_collision_point()

func move_to_body() -> void:
	PlayerModel.global_transform.origin = self.global_transform.origin
	PlayerModel.set_as_top_level(false)
	onledge=false
	raycast3.enabled=true
	disableMov=false
	anim_is_on_ledge=false
