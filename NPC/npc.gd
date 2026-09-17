extends CharacterBody3D


const SPEED = 1.5
const JUMP_VELOCITY = 4.5
var correr : bool = false

func _ready() -> void:
	$AnimationPlayer.play("Idle (1)/mixamo_com")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if correr:
		$AnimationPlayer.play("Goofy Running/mixamo_com")
		velocity.x -= SPEED * delta
	move_and_slide()
	
	
func alejarse() -> void:
	correr=true



func _on_area_3d_body_entered(body) -> void:
	if body.is_in_group("player"):
		$AnimationPlayer.play("Being Electrocuted/mixamo_com")
		alejarse()


func _on_casa_2_destroy() -> void:
	$AnimationPlayer.play("Idle (1)/mixamo_com")
	correr=false
	$CollisionShape3D.disabled=true
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_casa_destroy() -> void:
	$AnimationPlayer.play("Idle (1)/mixamo_com")
	correr=false
	$CollisionShape3D.disabled=true
	await get_tree().create_timer(0.1).timeout
	queue_free()
