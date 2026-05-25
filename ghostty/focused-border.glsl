// Focus indicator for Ghostty.
// Simulates the focused split as an elevated rounded card: soft shadow,
// subtle edge highlight, and almost no hard border.

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec4 base = texture(iChannel0, uv);

    if (iFocus <= 0) {
        fragColor = base;
        return;
    }

    vec2 px = fragCoord.xy;
    vec2 size = iResolution.xy;

    // Rounded rectangle inset from the split edges. This creates a softer
    // "selected card" feeling instead of a harsh rectangular terminal border.
    float inset = 3.0;
    float radius = 10.0;
    vec2 halfSize = (size * 0.5) - vec2(inset + radius);
    vec2 p = abs(px - size * 0.5) - halfSize;
    float roundedDistance = length(max(p, 0.0)) + min(max(p.x, p.y), 0.0) - radius;

    // Very soft edge. This is not meant to read as a hard border; it only
    // catches light so the selected split feels raised.
    float border = 1.0 - smoothstep(0.0, 1.8, abs(roundedDistance));

    // Ghostty doesn't preserve shader alpha as true window transparency here,
    // so elevation is simulated with a soft outer shadow and a soft highlight.
    float outside = smoothstep(1.2, 2.4, roundedDistance);
    float outerShadow = (1.0 - smoothstep(0.0, 30.0, roundedDistance)) * step(0.0, roundedDistance);
    float contactShadow = (1.0 - smoothstep(0.0, 8.0, roundedDistance)) * step(0.0, roundedDistance);
    float outerHalo = (1.0 - smoothstep(0.0, 12.0, roundedDistance)) * step(0.0, roundedDistance);

    // Inner card lift: gently brightens the inside near the rounded edge.
    float glow = 1.0 - smoothstep(-10.0, 0.0, roundedDistance);
    float inside = 1.0 - smoothstep(-1.0, 0.0, roundedDistance);
    float edgeBand = 1.0 - smoothstep(-18.0, -2.0, roundedDistance);

    // Directional light from top-left, like a raised card catching light.
    float topLight = 1.0 - smoothstep(0.0, size.y * 0.22, size.y - px.y);
    float leftLight = 1.0 - smoothstep(0.0, size.x * 0.22, px.x);
    float directionalHighlight = (topLight * 0.65 + leftLight * 0.35) * edgeBand * inside;

    vec3 borderColor = vec3(0.92, 0.92, 0.96);
    vec3 glowColor = vec3(0.74, 0.86, 1.0);
    vec3 liftColor = vec3(1.0, 0.98, 0.92);
    vec3 shadowColor = vec3(0.0, 0.0, 0.0);

    vec3 color = base.rgb;
    color = mix(color, shadowColor, outerShadow * 0.34);
    color = mix(color, shadowColor, contactShadow * 0.25);
    color = mix(color, glowColor, outerHalo * 0.007);
    color = mix(color, liftColor, directionalHighlight * 0.012);
    color = mix(color, glowColor, glow * 0.004);
    color = mix(color, iBackgroundColor, outside * 0.08);
    color = mix(color, borderColor, border * 0.035);

    fragColor = vec4(color, base.a);
}
