import PlaygroundSupport
import SceneKit

let scene = SCNScene()

var scnView: SCNView = {
    let v = SCNView()
    v.backgroundColor = UIColor.black
    v.allowsCameraControl = true
    v.showsStatistics = true
    return v
}()

scnView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
scnView.scene = scene

let sphere = SCNSphere(radius: 1.0)
let sphereNode = SCNNode(geometry: sphere)
sphereNode.position = SCNVector3(0.8, 1.2, 0.0)
//sphereNode.geometry?.firstMaterial?.transparencyMode = SCNTransparencyMode.default

let cube = SCNBox(width: 1.5, height: 1.5, length: 1.5, chamferRadius: 0.0)
let cubeNode = SCNNode(geometry: cube)
cubeNode.position = SCNVector3(-0.5, -0.5, 0.0)

scene.rootNode.addChildNode(sphereNode)
scene.rootNode.addChildNode(cubeNode)

let stencilPass: [String: Any] = [
    "program": "stencil",
    "inputs": [
        "a_vertex": "position-symbol",
        "modelViewProjection": "mvpt-symbol",
    ],
    "outputs": [
        "stencil": "COLOR"
//        "stencil": "DEPTH"
    ],
    "draw": "DRAW_NODE",
//    "colorStates": [
//        "clear": false
//    ]
    "stencilStates": [
        "enable": true,
//        "clear": true // default is false.
    ]
]

let embiggenPass: [String: Any] = [
    "program": "embiggen",
    "inputs": [
        "a_vertex": "position-symbol",
        "modelTransform": "mt-symbol",
        "viewTransform": "vt-symbol",
        "projectionTransform": "pt-symbol",
    ],
    "outputs": [
        "color": "COLOR"
    ],
    "draw": "DRAW_NODE",
    "colorStates": [
        "clear": true
    ],
    "stencilStates": [
//        "clear": true, // default is false.
        "behavior": [
            // If the depth test fails (i.e. frag is discarded).
            "depthFail": "keep",
            // If the depth test succeeds and the stencil test fails.
            "fail": "keep",
            // If the depth and stencil tests succeed.
            "pass": "zero",
            // The conditions under which the fragment passes the stencil test.
            "function": "greater"
        ]
    ]
]

let technique: [String: Any] = [
    "passes": [
        "embiggen": embiggenPass,
        "stencil": stencilPass
    ],
    "sequence": [
//        "embiggen", "stencil"
        "stencil", "embiggen"
    ],
    // In all passes, the following symbols (with these semantics) are available.
    "symbols": [
        "position-symbol": ["semantic": "vertex"],
        "mvpt-symbol": ["semantic": "modelViewProjectionTransform"],
        "mt-symbol": ["semantic": "modelTransform"],
        "vt-symbol": ["semantic": "viewTransform"],
        "pt-symbol": ["semantic": "projectionTransform"],
    ]
]

scnView.technique = SCNTechnique(dictionary: technique)

// Live view in assistant editor
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = scnView
