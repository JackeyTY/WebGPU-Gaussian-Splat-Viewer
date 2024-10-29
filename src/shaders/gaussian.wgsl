struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    //TODO: information passed from vertex shader to fragment shader
};

struct Splat {
    //TODO: information defined in preprocess compute shader
    xy: u32,
    wh: u32
};

@group(0) @binding(0)
var<storage, read> splats: array<Splat>;

@vertex
fn vs_main(
    @builtin(instance_index) instanceIndex: u32,
    @builtin(vertex_index) vertexIndex: u32
) -> VertexOutput {
    var out: VertexOutput;

    let splat = splats[instanceIndex];
    let xy = unpack2x16float(splat.xy);
    let wh = unpack2x16float(splat.wh);

    let corners = array<vec2f, 6>(
        vec2f(xy.x - wh.x, xy.y + wh.y),
        vec2f(xy.x - wh.x, xy.y - wh.y),
        vec2f(xy.x + wh.x, xy.y - wh.y),
        vec2f(xy.x + wh.x, xy.y - wh.y),
        vec2f(xy.x + wh.x, xy.y + wh.y),
        vec2f(xy.x - wh.x, xy.y + wh.y),
    );
    
    let pos = vec4(corners[vertexIndex].x, corners[vertexIndex].y, 0, 1);
    out.position = pos;

    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(1.);
}