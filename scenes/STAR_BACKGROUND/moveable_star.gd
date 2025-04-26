#-------------------------------------------------------------------------------
#                             __   __           __          
#    __ _  ___ _  _____ ___ _/ /  / /__    ___ / /____ _____
#   /  ' \/ _ \ |/ / -_) _ `/ _ \/ / -_)  (_-</ __/ _ `/ __/
#  /_/_/_/\___/___/\__/\_,_/_.__/_/\__/__/___/\__/\_,_/_/   
#                                    /___/                  
# class for background-art star that automagically moves itself to simulate 
# scrolling 
#-------------------------------------------------------------------------------

extends Sprite2D;

#-------------------------------------------------------------------------------
const SCROLL_PLANE_MIN : int = 1;
const SCROLL_PLANE_MAX : int = 4;
const MIN_Y            : float = -128.0; # allow some stars to start off-screen
const MAX_Y            : float = 600.0;  # change if changing the window height
const MAX_X            : float = 1024.0;

# how fast to travel down the screen on y (modulated by scroll plane below)
const STAR_SPEED_FACTOR  : float = 1.75;
const BASE_STAR_SPEED    : float = 0.5;

var which_scroll_plane : int = 1;
var star_sprite_height : int;

#-------------------------------------------------------------------------------
func _ready() -> void:
	# capture this for later, where we use it to make sure that
	# we're all the way offscreen when respawning ourselves
	star_sprite_height = int(self.texture.get_size().y);
		
	# spawn at a random location	
	position.x         = randf_range(0.0, MAX_X);
	position.y         = randf_range(MIN_Y, MAX_Y);

	# place myself at one of four imaginary scroll planes, which tell me
	# how fast to move and what my brightness should be
	which_scroll_plane = randi_range(SCROLL_PLANE_MIN, SCROLL_PLANE_MAX);
	
	# adjust brightness based on what plane I'm in. Since we'll be drawn with
	# addition, darker colours give me fainter (farther away) look
	var brightness     = (1.0/float(which_scroll_plane));
	modulate           = Color(brightness, brightness, brightness);

	return;
	
#-------------------------------------------------------------------------------
func _process(_ignored) -> void:
	# move
	position.y += (STAR_SPEED_FACTOR / which_scroll_plane) + BASE_STAR_SPEED;
	
	# am I off the bottom?
	if (position.y > (MAX_Y + star_sprite_height)):
		# yep, respawn somewhere off the top
		position.x    = randf_range(0.0, MAX_X);
		position.y    = randf_range(MIN_Y, 0.0 - star_sprite_height);
		
	return;
