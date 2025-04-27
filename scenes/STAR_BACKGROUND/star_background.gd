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
const NEBULA_SPEED : float = 0.4;
const GALAXY_SPEED : float = 1.2;

# these should be treated as constants - we load them below
var   NEBULA_TEXTURE_HEIGHT : int;
var   GALAXY_TEXTURE_HEIGHT : int;
var   DISPLAY_HEIGHT        : int;

# which galaxy should we be painting right now?
var   which_galaxy          : int;
var   which_galaxy_prev     : int;
const MIN_GALAXY            : int = 1;
const MAX_GALAXY            : int = 4;

var   galaxy_textures       : Array = [];
var   galaxy_change_pending : bool  = false;

#-------------------------------------------------------------------------------                 
func _ready() -> void:
	# stars
	for star_index in range(0, NUM_MOVEABLE_STARS):
		var star_tmp = MOVEABLE_STAR.instantiate();
		add_child(star_tmp);
		# no need to manage the stars after they're inited, they'll take care of
		# their own anims and die when we do
	
	# galaxies
	galaxy_textures.resize(MAX_GALAXY);
	
	for galaxy_index in range(0, MAX_GALAXY):
		var image_filename : String = "res://scenes/STAR_BACKGROUND/background_scroll_0" + \
			str(galaxy_index + 1) + ".png";
		galaxy_textures[galaxy_index] = load(image_filename) as Texture;
	
	# cache the sprite & viewport sizes to reduce the # of function calls we
	# have to make later
	NEBULA_TEXTURE_HEIGHT = $BackgroundNebula.texture.get_size().y * \
		$BackgroundNebula.scale.y;
	
	# in the real world, we'd store all of the sizes individually.
	# I made them all the same height for simplicity because it's a demo.	
	GALAXY_TEXTURE_HEIGHT = galaxy_textures[0].get_size().y * \
		$galaxy_bg_next.scale.y;
	DISPLAY_HEIGHT        = int(get_viewport().size.y);

	# start with galaxy background one
	which_galaxy          = MIN_GALAXY;
	which_galaxy_prev     = MIN_GALAXY;
	galaxy_change_pending = false;
	return;

#-------------------------------------------------------------------------------                 
func set_galaxy(arg_galaxy_type : int) -> void:
	if not (galaxy_change_pending):
		which_galaxy_prev = which_galaxy;
	
	which_galaxy          = clampi(arg_galaxy_type, MIN_GALAXY, MAX_GALAXY);
	galaxy_change_pending = true;
	return;

#-------------------------------------------------------------------------------                 
func _process(_ignored: float) -> void:
	# nebula plane
	$BackgroundNebula.position.y += NEBULA_SPEED;
	if ($BackgroundNebula.position.y >= NEBULA_TEXTURE_HEIGHT):
		$BackgroundNebula.position.y = 0;

	# galaxy plane
	$galaxy_bg_next.position.y += GALAXY_SPEED;
	# off the bottom?
	if ($galaxy_bg_next.position.y >= GALAXY_TEXTURE_HEIGHT):
		$galaxy_bg_next.position.y = 0;
		
		# did we have a galaxy change pending?
		if (which_galaxy_prev != which_galaxy):
			$galaxy_bg_prev.texture = galaxy_textures[which_galaxy-1];
			which_galaxy_prev = which_galaxy;
			galaxy_change_pending = false;
		else:
			# trailing galaxy already correct, update leading galaxy
			$galaxy_bg_next.texture = $galaxy_bg_prev.texture;

	# move trailing galaxy, too
	$galaxy_bg_prev.position.y = $galaxy_bg_next.position.y - GALAXY_TEXTURE_HEIGHT; 			
