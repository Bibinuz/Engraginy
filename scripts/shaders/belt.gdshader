shader_type spatial;

uniform sampler2D belt_texture : source_color, filter_linear_mipmap_anisotropic;
uniform vec3 side_color : source_color = vec3(0.1, 0.1, 0.1); // Color for the static sides
uniform float tiling_factor = 1.0;
instance uniform float speed = 0.5;
instance uniform float custom_time = 0.0;

varying float is_side_face;
varying float is_front_face;
varying float is_top_face;

void vertex() {
    // 1. Get the global scale on the X axis
    float scale_x = length(MODEL_MATRIX[0].xyz);
	float scale_y = length(MODEL_MATRIX[1].xyz);

    // 2. Identify if this vertex belongs to a side face (Normal pointing Left/Right)
    // Returns 1.0 if it is a side, 0.0 if it is Top/Bottom/Front/Back
    is_side_face = step(0.5, abs(NORMAL.y));
	is_front_face = step(0.5, abs(NORMAL.x));
	is_top_face = step(0.5, abs(NORMAL.z));

    // 3. Apply Scaling
    // If it's a side, keep scale 1.0. If it's the belt, use the object's X scale.
 	float final_scale = 1.0;
   	if(is_front_face > 0.9)
	{
		final_scale = 0.5;
	}
	else if(is_top_face > 0.9)
	{
		final_scale = mix(scale_x, 1.0, is_side_face);
	}


	UV.x *= final_scale * tiling_factor;

    // 4. Apply Animation Condition
    // We multiply the time offset by (1.0 - is_side_face).
    // If is_side_face is 1.0, the result is 0.0 (No movement).
    // If is_side_face is 0.0, the result is 1.0 (Movement enabled).
    UV.x += -speed * custom_time * (1.0 - is_side_face);
}

void fragment() {
    // Sample the texture for the belt parts
    vec3 belt_albedo = texture(belt_texture, UV).rgb;

    // 5. Choose the final color
    // If is_side_face is 1.0, use side_color. Otherwise, use the texture.
    ALBEDO = mix(belt_albedo, side_color, is_side_face);

    // Optional: Keep visual properties
    ROUGHNESS = 0.6;
    SPECULAR = 0.2;
}