shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
varying float grain_amount;// : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grainsw
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; // Adjust the size of the grain
uniform bool animate = false;



uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 color1 : source_color;
uniform vec4 color2 : source_color;
uniform vec4 color3 : source_color;
uniform vec4 color4 : source_color;
uniform vec4 color5 : source_color;
uniform vec4 color6 : source_color;

void fragment() {

	vec4 original_color = texture(screen_texture, SCREEN_UV);
	float color_amount = ((original_color.r + original_color.g + original_color.b - 3.0) * -1.0);

	if(color_amount < 2.2){
		grain_amount = 0.01;
	}
	else{
		grain_amount = 0.08;
	}
	if(color_amount < 0.2){
		 grain_amount = 0.0;
	}
	//remove grain
	grain_amount = 0.0;
	//if(color_amount < 0.5){
		 //float grain_amount = 1.0;
	//}

	//float grain_amount = ((original_color.r + original_color.g + original_color.b - 3.0) * -1.0)/16.0;

	float noise = 0.0;

	if (animate) {
		// Generate random noise
		noise = (fract(sin(dot(UV * floor(TIME), vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;
	} else {
		 noise = (fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;
	}
	// Add noise to the original color
	original_color.rgb += noise * grain_amount * grain_size;

	// Clamp the final color to make sure it stays in the valid range
	vec4 COLORgrain = clamp(original_color, 0.0, 1.0);







	vec4 colors[6] = {color1, color2, color3, color4, color5, color6};
	float min_diff = -1.0;
	vec4 min_color = vec4(0.0, 0.0, 0.0, 1.0);

	vec2 uv = SCREEN_UV;

	vec4 temp = textureLod(SCREEN_TEXTURE, uv, 0.0);

	min_diff = 1000.0;
	for (int i = 0; i < colors.length(); i++) {

		float curr_dist = distance(colors[i], temp);
		if (curr_dist < min_diff) {
			min_diff = curr_dist;
			min_color = colors[i];
		}
	}

	COLOR.rgb = min_color.rgb + (COLORgrain.rgb/8.0);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
