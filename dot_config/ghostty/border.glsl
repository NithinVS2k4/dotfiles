// pane-border.glsl
// Draws a colored border around the focused pane.
// ------------------------------------------------------------
// CONFIGURATION (edit these values)
// Border thickness in pixels (integer, try 2–4)
const int BORDER_WIDTH = 2;
// Colors (RGBA, 0.0 to 1.0)
const vec4 FOCUSED_COLOR   = vec4(1.0, 1.0, 1.0, 1.0); // blue
const vec4 UNFOCUSED_COLOR = vec4(0.4, 0.4, 0.4, 1.0); // gray
// ------------------------------------------------------------


void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Sample the original terminal content (from previous shaders or default render)
    vec2 uv = fragCoord / iResolution.xy;
    vec4 texColor = texture(iChannel0, uv);
    
    // Determine if we are near an edge within BORDER_WIDTH pixels
    float x = fragCoord.x;
    float y = fragCoord.y;
    float w = iResolution.x;
    float h = iResolution.y;
    
    bool onLeft   = x < float(BORDER_WIDTH);
    bool onRight  = x > w - float(BORDER_WIDTH);
    bool onTop    = y < float(BORDER_WIDTH);
    bool onBottom = y > h - float(BORDER_WIDTH);
    
    bool onBorder = onLeft || onRight || onTop || onBottom;
    
    // Choose border color based on focus state
    vec4 borderColor = (iFocus > 0) ? FOCUSED_COLOR : UNFOCUSED_COLOR;
    
    // Blend: if on border, use border color; otherwise keep original
    if (onBorder) {
        fragColor = borderColor;
    } else {
        fragColor = texColor;
    }
}
