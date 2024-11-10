extends CharacterBody3D



const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var state_machine = $AnimationTree.get("parameters/Top_Movement/playback")
@onready var animSys = $AnimationTree




@onready var camera_Location = $camera_locator
@onready var charPoint = $character_waypoint
@onready var mouse_position3D: Vector3
@onready var player_raw_stamina = float(10)
@onready var sprinting = false
@export var Sprite_node: Texture2D


@export var has_armor: bool
@export var has_mask: bool

@onready var camera_focused = false
var Camera_Pivot: Vector3

@onready var Anim_Walk_Inten: float = 0
@onready var Anim_Walk_Speed: float = 0

func _ready() -> void:
	vario.zone_transition.connect(center_camera)
	mouse_position3D = Vector3(0,0,2)
	get_node("PLAYER_MODEL/star/Skeleton3D/maska").visible = has_mask
	get_node("PLAYER_MODEL/star/Skeleton3D/heavy armor").visible = has_armor
	
##PLAYER INFO SYSTEM
	vario.insert_ui("res://bin/player hud.tscn")
	vario.add("ACTIVE_PLAYER_CLASS",self)
func _process(delta: float) -> void:
	if Input.is_action_just_released("inventory"):
		visible = false
		vario.insert_ui("res://bin/playermenu.tscn")
	
	if vario.GAME_PAUSED == false:
		visible = true
func _physics_process(delta: float) -> void:
	vario.minimap_mark("PLAYER_MARKER", global_position,Sprite_node,1)
	
	var playerRawVelocity = global_position.distance_to(charPoint.global_position)
	var VELOCITY_SPEED = 1.5



	vario.add("PLAYER_HUD_STAMINABAR", get_node("camera_locator/camera_pivot/Camera3D").unproject_position(get_node("stamina_bar_location").global_position))
	
	
	vario.add_per("PLAYER_INFO_STAMINA", player_raw_stamina)
	
	if Input.is_action_pressed("sprint"):	
		if playerRawVelocity > 0.1:
			if sprinting == true and player_raw_stamina > 1:
				player_raw_stamina -= 1 * delta
				VELOCITY_SPEED = 5
			else:
				VELOCITY_SPEED = 2.5
			if sprinting == false and player_raw_stamina > 5:
				sprinting = true	
	else:
		VELOCITY_SPEED = 1.5
		if player_raw_stamina < 10:
			player_raw_stamina += 1.5 * delta
		sprinting = false
		
	
	
	charPoint.velocity.x = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	charPoint.velocity.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backwards") 
	charPoint.velocity.z /= 2
	charPoint.velocity = charPoint.velocity.normalized() * VELOCITY_SPEED

	charPoint.move_and_slide()
	if Vector2(charPoint.velocity.x,charPoint.velocity.z).is_equal_approx(Vector2(0,0)):
		charPoint.look_at(mouse_position3D)
	else:
		charPoint.look_at(charPoint.global_position + charPoint.velocity)
	

	if is_equal_approx(playerRawVelocity,0):
		if is_equal_approx(snapped(global_rotation.y,0.01), snapped(charPoint.global_rotation.y,0.001)) == false:
			var rotA = global_rotation.y
			var rotB = charPoint.global_rotation.y
			if global_rotation.y > charPoint.global_rotation.y:
				state_machine.travel("turn_right", false) 
				
				Anim_Walk_Inten = 0
				Anim_Walk_Speed = rotA-rotB if rotA-rotB <= 2 else 2 
			else:
				state_machine.travel("turn_left", false)
				Anim_Walk_Inten = 0
				Anim_Walk_Speed = rotB-rotA if rotB-rotA <= 2 else 2
		else:
			Anim_Walk_Inten = lerpf(Anim_Walk_Inten,1, delta * 10)
			Anim_Walk_Speed = lerpf(Anim_Walk_Speed,0, delta * 10)
		animSys.set("parameters/TimeScale/scale", Anim_Walk_Speed)
		animSys.set("parameters/Move_Intensity/blend_amount",Anim_Walk_Inten)
	else:
		state_machine.travel("walk", false) 
		Anim_Walk_Inten = lerpf(Anim_Walk_Inten,playerRawVelocity * 3, delta * 20)
		Anim_Walk_Speed = lerpf(Anim_Walk_Speed,0.5 + ((VELOCITY_SPEED/4) * 0.5), delta * 20)
		animSys.set("parameters/TimeScale/scale", Anim_Walk_Speed - (Anim_Walk_Inten * 0.15))
		animSys.set("parameters/Move_Intensity/blend_amount", ((1 - Anim_Walk_Inten)/1) )


		
	global_rotation.y = lerp_angle(global_rotation.y,charPoint.global_rotation.y, delta * 2.5)
	global_position = global_position.lerp(Vector3(charPoint.global_position.x, 0 , charPoint.global_position.z), delta * 10)
	
	if get_node("camera_follow_player").global_position.distance_to(global_position) > 3.5:
		camera_focused = false
	if get_node("camera_follow_player").global_position.distance_to(global_position) < 0.1:
		camera_focused = true
	
	if camera_focused == false:
		get_node("camera_follow_player").global_position = get_node("camera_follow_player").global_position.lerp(global_position, delta * VELOCITY_SPEED)
		
	camera_Location.global_position = camera_Location.global_position.lerp(get_node("camera_follow_player").global_position, delta * (VELOCITY_SPEED*2))
	get_node("camera_locator/camera_pivot").position = get_node("camera_locator/camera_pivot").position.lerp(Camera_Pivot,delta * 2.5)

	if Input.is_action_pressed("aiming") and Input.is_action_pressed("sprint") == false:
		Camera_Pivot.x = -0.015 * (vario.mouse_position.x - 320)
		Camera_Pivot.z = -0.02 * (vario.mouse_position.y - 180)
	else:
		Camera_Pivot = Vector3(0,0,0)
		
		


func teleport(destination: Vector3):
	velocity = Vector3(0,0,0)
	global_position = destination
	velocity = Vector3(0,0,0)

func center_camera() -> void:
	get_node("camera_locator").global_position = global_position
	



func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	mouse_position3D = Vector3(event_position.x, 0, event_position.z)
