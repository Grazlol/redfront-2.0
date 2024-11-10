extends Sprite2D

@onready var camera = $SubViewport2/SubViewportContainer/SubViewport/Camera3D
@onready var camera_settings = $SubViewport2/SubViewportContainer/SubViewport/Camera3D/Camera3D
@onready var flashlight = $SubViewport2/SubViewportContainer/SubViewport/Camera3D/Camera3D/OmniLight3D
@onready var markers = $SubViewport2/objective_markers
@onready var markercoords: Dictionary
@onready var charlight = $SubViewport2/SubViewportContainer/SubViewport/character_light
@onready var outline_render = $SubViewport2/SubViewportContainer2/SubViewport/Camera3D/Camera3D

@onready var render_target = $SubViewport2

@onready var zoom = float(20)
@onready var camspeed = float(0.5)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	if vario.minimapitems != null:
		for elements in vario.minimapitems:
			var tempar = vario.minimapitems[elements]
			var marker_coord = tempar[1]
			var marker_tex = tempar[0]
			markercoords[marker_tex] = marker_coord
			markers.add_child(marker_tex)
	camera.global_position = vario.fetch("ACTIVE_PLAYER_CLASS").global_position
	charlight.global_position = vario.fetch("ACTIVE_PLAYER_CLASS").global_position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for element in markercoords:
		element.position = camera_settings.unproject_position(markercoords[element])


func _physics_process(delta: float) -> void:
	camera_settings.global_position.x += camspeed * (Input.get_action_strength("move_left") - Input.get_action_strength("move_right"))
	camera_settings.global_position.z += camspeed * (Input.get_action_strength("move_forward") - Input.get_action_strength("move_backwards"))
	if Input.is_action_just_pressed("key_q") and zoom < 100:
		zoom += 5
		camspeed += 0.2
	if Input.is_action_just_pressed("key_e") and zoom > 10:
		zoom -= 5
		camspeed -= 0.2
	
	camera_settings.global_position.y = zoom
	outline_render.global_position = camera_settings.global_position
	outline_render.size = camera_settings.size
	get_node("SubViewport2/CanvasLayer/sensor density").text = str("[SENSOR DENSITY]:[" + str(zoom) + "]")
	get_node("SubViewport2/CanvasLayer/phase speed").text = str("[PHASE SPEED]:[" + str(camspeed) + "]")
	get_node("SubViewport2/CanvasLayer/range").text = str("[RANGE]:[" + str(snapped(Vector3(camera_settings.global_position.x, 0 ,camera_settings.global_position.z).distance_to(Vector3(camera.global_position.x, 0, camera.global_position.z)),0.001)) + "][METERS]")
	get_node("SubViewport2/CanvasLayer/coordinates").text = str("[X:"+str(snapped(camera_settings.global_position.x,0.001))+"]"+"[Y:"+str(snapped(camera_settings.global_position.z,0.001))+"]")
func _on_calibrate_pressed() -> void:
	camera_settings.position.x = 0
	camera_settings.position.z = 0
	
