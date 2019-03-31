shader_type canvas_item;

uniform bool shouldOutline;
uniform float width : hint_range(0.0, 30.0);
uniform vec4 outline_colour : hint_color;

void fragment() {
	float size = width * 1.0 / float(textureSize(TEXTURE, 0).x);
	vec4 sprite_colour = texture(TEXTURE, UV);
	float alpha = -8.0 *  sprite_colour.a;
	
	alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, size)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -size)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, size)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, -size)).a;
	alpha += texture(TEXTURE, UV + vec2(size, -size)).a;
	alpha += texture(TEXTURE, UV + vec2(size, -size)).a;
	
	vec3 final_colour = mix(sprite_colour.rgb, outline_colour.rgb, clamp(alpha, 0.0, 1.0));
	if (shouldOutline) {
		COLOR = vec4(final_colour.rgb, clamp(abs(alpha) + sprite_colour.a, 0.0, 1.0));
	} else {
		COLOR = sprite_colour;
	}
}