shader_type canvas_item;
render_mode unshaded;

// Цвета для каждого уровня постеризации
uniform vec4 level1 : source_color = vec4(0.0, 0.0, 0.0, 1.0);    // Тёмный
uniform vec4 level2 : source_color = vec4(0.3, 0.3, 0.3, 1.0);    // Серый
uniform vec4 level3 : source_color = vec4(0.7, 0.7, 0.7, 1.0);    // Светлый
uniform vec4 level4 : source_color = vec4(1.0, 1.0, 1.0, 1.0);    // Яркий

// Пороги для разделения уровней (0-1)
uniform float threshold1 : hint_range(0.0, 1.0) = 0.25;  // level1 -> level2
uniform float threshold2 : hint_range(0.0, 1.0) = 0.5;   // level2 -> level3
uniform float threshold3 : hint_range(0.0, 1.0) = 0.75;  // level3 -> level4

// Текстура экрана (если нужно обработать весь CanvasLayer)
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// Интенсивность эффекта (0 = нет эффекта, 1 = полная постеризация)
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    // Получаем исходный цвет (с экрана или текстуры ColorRect)
    vec4 original_color = texture(screen_texture, SCREEN_UV);

    // Вычисляем среднюю яркость
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

    // Смешиваем с оригиналом для плавности
    COLOR = mix(original_color, posterized_color, intensity);
}