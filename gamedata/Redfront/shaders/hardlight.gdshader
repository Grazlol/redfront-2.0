shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {

    // Get the current texture color

    vec4 tex_color = texture(TEXTURE, UV);


    // Get the color of the elements below

    vec4 below_color = texture(SCREEN_TEXTURE, SCREEN_UV);

	vec4 limit = step(0.5, tex_color);
	COLOR = mix(2.0 * tex_color * below_color, 1.0 - 2.0 * (1.0 - tex_color) * (1.0 - below_color), limit);


	
}