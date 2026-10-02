#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 colorBorder;
};

layout(binding = 1) uniform sampler2D source;

const float blend = 0.01;
const float innerRadius = 0.47;
const float outerRadius = 0.49;
const vec4 colorEmpty = vec4(0.0, 0.0, 0.0, 0.0);

void main() {
    vec4 colorSource = texture(source, qt_TexCoord0.st);

    vec2 m = qt_TexCoord0 - vec2(0.5, 0.5);
    float dist = sqrt(m.x * m.x + m.y * m.y);

    vec4 result;
    if (dist < innerRadius)
        result = colorSource;
    else if (dist < innerRadius + blend)
        result = mix(colorSource, colorBorder, ((dist - innerRadius) / blend));
    else if (dist < outerRadius)
        result = colorBorder;
    else if (dist < outerRadius + blend)
        result = mix(colorBorder, colorEmpty, ((dist - outerRadius) / blend));
    else
        result = colorEmpty;

    fragColor = result * qt_Opacity;
}
