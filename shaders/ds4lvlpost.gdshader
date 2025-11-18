shader_type canvas_item;
render_mode unshaded;

// Цвета уровней (можно менять в инспекторе)
uniform vec4 level1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);   // Тёмный
uniform vec4 level2 : source_color = vec4(0.33, 0.33, 0.33, 1.0); // Средний
uniform vec4 level3 : source_color = vec4(0.66, 0.66, 0.66, 1.0); // Светлый
uniform vec4 level4 : source_color = vec4(1.0, 1.0, 1.0, 1.0);    // Яркий

// Пороги яркости (0-1)
uniform float threshold1 : hint_range(0.0, 1.0) = 0.25;
uniform float threshold2 : hint_range(0.0, 1.0) = 0.5;
uniform float threshold3 : hint_range(0.0, 1.0) = 0.75;

// Основные настройки
uniform float intensity : hint_range(0.0, 1.0) = 1.0; // Сила эффекта
uniform float edge_smoothness : hint_range(0.0, 0.2) = 0.05; // Сглаживание переходов

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
    // Получаем исходный цвет (без пикселизации!)
    vec4 original_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    
    // Вычисляем яркость
    float brightness = (original_color.r + original_color.g + original_color.b) / 3.0;
    
    // Плавные переходы между уровнями
    vec4 posterized_color;
    float t = smoothstep(threshold1 - edge_smoothness, threshold1 + edge_smoothness, brightness);
    posterized_color = mix(level1, level2, t);
    
    t = smoothstep(threshold2 - edge_smoothness, threshold2 + edge_smoothness, brightness);
    posterized_color = mix(posterized_color, level3, t);
    
    t = smoothstep(threshold3 - edge_smoothness, threshold3 + edge_smoothness, brightness);
    posterized_color = mix(posterized_color, level4, t);
    
    // Финальное смешивание
    COLOR = mix(original_color, posterized_color, intensity);
}