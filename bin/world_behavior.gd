extends Node3D

@export var WorldName: String
@export var FogEnabled: bool
@export var FogColor: Color
@export var LevelTonemap: Texture
@export_range(0,2) var LevelBrightness = float(1)
@export_range(0,2) var LevelSaturation = float(1)
@export_range(0,2) var LevelContrast = float(1)
@export var Ambient_Light_Color: Color
@export_range(0,2) var Ambient_Light_Intensity = float(1)


@onready var playerpack = load("res://gamedata/actors/PLAYER/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vario.add("ENV_fog?", FogEnabled)
	vario.add("ENV_fogColor", FogColor)
	vario.add("ENV_tonemap", LevelTonemap)
	vario.add("ENV_localbrightness", LevelBrightness)
	vario.add("ENV_localsaturation", LevelSaturation)
	vario.add("ENV_localcontrast", LevelContrast)
	vario.add("ENV_Ambient_Light_Color", Ambient_Light_Color)
	vario.add("ENV_Ambient_Light_Intensity", Ambient_Light_Intensity)
	var new_player = playerpack.instantiate()
	add_child(new_player)
	vario.environmentrefresh.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
