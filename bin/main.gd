extends Control


@export_enum("SHIPPING MODE", "TESTING MODE") var LAUNCH_PARAM: String
@export var DEBUG_MAP: String
@export var next_node: Node
@export_enum("P1","P2","P3","P4","P5") var PLAYER_SLOT = "P1"
@onready var gamelayer = $playLayer/SubViewportContainer/fullRender/RENDER

var Opened = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vario.playername = PLAYER_SLOT
	vario.fadeOut.connect(fadeout)
	vario.pushNode.connect(pushNode)
	vario.set_Next.connect(_on_controller_set_next)
	vario.add("LOADING_SCREEN_ENABLED?", false)
	vario.INITIATE_SAVE.connect(save_game)
	vario.INITIATE_LOAD.connect(load_game)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	vario.mouse_position = get_local_mouse_position()
	if !Opened:
		match LAUNCH_PARAM:
			"TESTING MODE":
				vario.map(DEBUG_MAP)
			
			"SHIPPING MODE":
				vario.map("res://gamedata/Redfront/level/pregame/main_menu.tscn")
		
		Opened = true

func _physics_process(delta: float) -> void:
	if vario.GAME_PAUSED:
		get_tree().paused = true
	else:
		get_tree().paused = false
		
func pushNode(layer: String, nodetype: Node) -> void:
	get_node("playLayer/SubViewportContainer/fullRender/" + layer).add_child(nodetype)

func fadeout() -> void:
	get_node("fade_oute").play("fade")
	
func fadein() -> void:
	pass

func _on_fade_oute_animation_finished(anim_name: StringName) -> void:
	if get_node("playLayer/SubViewportContainer/fullRender/RENDER").get_child(0) != null:
		get_node("playLayer/SubViewportContainer/fullRender/RENDER").get_child(0).queue_free()
	get_node("loading_screen/SubViewportContainer/SubViewport/loadingscreen").play_animation()
	await vario.SYNCHRONIZITÄT
	pushNode("RENDER",next_node)
	var fadeiner = get_node("fade_into")
	fadeiner.play("fade")


func _on_controller_set_next(NodeType: Node) -> void:
	next_node = NodeType

func save_game() -> void:
	var pathname = "res://savegames/"+vario.packed_scene_name+".tscn"
	var scene = PackedScene.new()
	var result = scene.pack(get_node("playLayer/SubViewportContainer").get_child(0))
	if result == OK:
		var error = ResourceSaver.save(scene, pathname)  # Or "user://..."
		vario.add_per("SAVE_GAME_DIRECTORY",pathname)
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")
	
func load_game() -> void:
	vario.add("LOADING_SCREEN_ENABLED?", true)
	
	var newLoad = load(vario.fetch_per("SAVE_GAME_DIRECTORY")).instantiate()
	var LoadChild = newLoad.instantiate()
	
	get_node("loading_screen/SubViewportContainer/SubViewport/loadingscreen").play_animation()
	await vario.SYNCHRONIZITÄT
	get_node("playLayer/SubViewportContainer").get_child(0).queue_free()
	get_node("playLayer/SubViewportContainer").add_child(LoadChild)
	
	
