shader_type canvas_item;

uniform bool isInVent;

void fragment() {
	
	vec4 sprite_colour = texture(TEXTURE, UV);
	if (isInVent) {
		//sprite_colour.a = 0.5;
	} else {
		//sprite_colour.a = 1.0;
	}
	
	COLOR = sprite_colour;
}