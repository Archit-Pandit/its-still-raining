extends Node2D

@onready var terrainCol = $CollisionPolygon2D
@onready var terrainShape = $CollisionPolygon2D/Polygon2D

func _ready():
    terrainShape.polygon = terrainCol.polygon
