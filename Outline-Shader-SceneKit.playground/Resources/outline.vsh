// Vertex Shader for stencil pass

attribute vec4 a_vertex;

uniform mat4 modelViewProjection;

void main() {
    
    gl_Position = modelViewProjection * a_vertex;
    
}
