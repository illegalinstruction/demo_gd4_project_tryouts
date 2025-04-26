#-------------------------------------------------------------------------------      
#         ______            ___           __                              __
#        / __/ /____ _____ / _ )___ _____/ /_____ ________  __ _____  ___/ /
#       _\ \/ __/ _ `/ __// _  / _ `/ __/  '_/ _ `/ __/ _ \/ // / _ \/ _  / 
#      /___/\__/\_,_/_/__/____/\_,_/\__/_/\_\\_, /_/  \___/\_,_/_//_/\_,_/  
#                    /___/                  /___/                           
#   self-contained, reusable scene that draws a 2d scrolling space background;
#   can be told to draw different galaxy (for example, when changing levels)
#-------------------------------------------------------------------------------                 

extends Node2D;

#-------------------------------------------------------------------------------                 
# the parent class of the moveable stars drawn on top of the galaxy & nebula
@onready var MOVEABLE_STAR = load("res://scenes/STAR_BACKGROUND/moveable_star.tscn");

# how many moveable stars can we have active at once?
const NUM_MOVEABLE_STARS : int = 64;

#-------------------------------------------------------------------------------                 
const NEBULA_SPEED : float = 0.33333333333;
const GALAXY_SPEED : float = 0.125;

# these should be treated as constants - we load them below
var   NEBULA_TEXTURE_HEIGHT : int;
var   DISPLAY_HEIGHT        : int;

#-------------------------------------------------------------------------------                 
func _ready() -> void:
	for star_index in range(0, NUM_MOVEABLE_STARS):
		var star_tmp = MOVEABLE_STAR.instantiate();
		add_child(star_tmp);
		# no need to manage the stars after they're inited, they'll take care of
		# their own anims and die when we do
	
	# cache the sprite & viewport sizes to reduce the # of function calls we
	# have to make later
	NEBULA_TEXTURE_HEIGHT = $BackgroundNebula.texture.get_size().y * \
		$BackgroundNebula.scale.y;
	DISPLAY_HEIGHT        = int(get_viewport().size.y);

	return;

#-------------------------------------------------------------------------------                 
func _process(_ignored: float) -> void:
	# nebula plane
	$BackgroundNebula.position.y += NEBULA_SPEED;
	if ($BackgroundNebula.position.y >= NEBULA_TEXTURE_HEIGHT):
		$BackgroundNebula.position.y = 0;

	# galaxy plane
	$BackgroundScroll01_00.position.y += GALAXY_SPEED;
	if ($BackgroundScroll01_00.position.y >= DISPLAY_HEIGHT):
		$BackgroundScroll01_00.position.y = 0;
