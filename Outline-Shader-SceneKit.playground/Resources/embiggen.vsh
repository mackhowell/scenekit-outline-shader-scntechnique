// Vertex Shader for embiggen pass

attribute vec4 a_vertex;

uniform mat4 modelTransform;
uniform mat4 viewTransform;
uniform mat4 projectionTransform;

void main() {
    
    float scaleFactor = 1.075;
    vec4 scaledVertex = a_vertex * scaleFactor;
    gl_Position = projectionTransform * viewTransform * modelTransform * vec4(scaledVertex.xyz, 1.0);
}

