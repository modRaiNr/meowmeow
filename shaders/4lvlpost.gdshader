shader_type canvas_item;
render_mode unshaded;

uniform vec4 level1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 level2 : source_color = vec4(0.33, 0.33, 0.33, 1.0);
uniform vec4 level3 : source_color = vec4(0.66, 0.66, 0.66, 1.0);
uniform vec4 level4 : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float threshold1 : hint_range(0.0, 1.0) = 0.25;
uniform float threshold2 : hint_range(0.0, 1.0) = 0.5;
uniform float threshold3 : hint_range(0.0, 1.0) = 0.75;

uniform float intensity : hint_range(0.0, 1.0) = 0.5; // Сила эффекта
uniform float pixel_size : hint_range(1.0, 100.0) = 1.0; // Размер пикселей

void fragment() {
    // Получаем исходный цвет с экрана
    vec2 pixel_uv = floor(SCREEN_UV * pixel_size) / pixel_size;
    vec4 original_color = texture(screen_texture, pixel_uv);
    
    // Вычисляем яркость
    float brightness = (original_color.r + original_color.g + original_color.b) / 3.0;
    
    // Определяем уровень постеризации
    vec4 posterized_color;
    if (brightness < threshold1) {
        posterized_color = level1;
    } else if (brightness < threshold2) {
        posterized_color = level2;
    } else if (brightness < threshold3) {
        posterized_color = level3;
    } else {
        posterized_color = level4;
    }
    
    // Аккуратно смешиваем с оригиналом
    COLOR = mix(original_color, posterized_color, intensity);
}