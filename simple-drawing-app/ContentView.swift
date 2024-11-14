import SwiftUI

struct ContentView: View {
    // State to manage drawing paths, colors, brush size, undo stack, and the eraser tool
    @State private var paths: [DrawingPath] = []
    @State private var undonePaths: [DrawingPath] = []
    @State private var currentColor: Color = .black
    @State private var brushSize: CGFloat = 5.0
    @State private var currentPath: DrawingPath = DrawingPath(color: .black, points: [])
    @State private var isEraserActive: Bool = false // State for eraser tool

    var body: some View {
        VStack {
            // Brush size, color selector, and tools (Eraser)
            HStack {
                Button(action: {
                    currentColor = .black
                    isEraserActive = false
                }) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 30, height: 30)
                }
                Button(action: {
                    currentColor = .red
                    isEraserActive = false
                }) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 30, height: 30)
                }
                Button(action: {
                    currentColor = .blue
                    isEraserActive = false
                }) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                }
                Button(action: {
                    currentColor = .green
                    isEraserActive = false
                }) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 30, height: 30)
                }
                Button(action: {
                    currentColor = .yellow
                    isEraserActive = false
                }) {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 30, height: 30)
                }
                
                Button(action: {
                    isEraserActive.toggle()
                    if isEraserActive {
                        currentColor = .white // Erase by drawing with white color
                    } else {
                        currentColor = .black // Switch back to drawing with black
                    }
                }) {
                    Image(systemName: isEraserActive ? "pencil.slash" : "eraser")
                        .font(.title)
                        .foregroundColor(isEraserActive ? .red : .black)
                        .frame(width: 40, height: 40)
                }
                
                Slider(value: $brushSize, in: 1...30, step: 1) {
                    Text("Brush Size")
                }
                .padding(.leading)
            }
            .padding()

            // Drawing canvas
            Canvas { context, size in
                // Draw all paths
                for path in paths {
                    var pathToDraw = Path()
                    for (index, point) in path.points.enumerated() {
                        if index == 0 {
                            pathToDraw.move(to: point)
                        } else {
                            pathToDraw.addLine(to: point)
                        }
                    }
                    context.stroke(pathToDraw, with: .color(path.color), lineWidth: brushSize)
                }

                // Draw current path being drawn
                var tempPath = Path()
                for (index, point) in currentPath.points.enumerated() {
                    if index == 0 {
                        tempPath.move(to: point)
                    } else {
                        tempPath.addLine(to: point)
                    }
                }
                context.stroke(tempPath, with: .color(currentPath.color), lineWidth: brushSize)
            }
            .background(Color.white)
            .border(Color.gray, width: 1)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let newPoint = value.location
                        currentPath.points.append(newPoint) // Add point to the current path
                    }
                    .onEnded { _ in
                        // Add the path (whether it's a drawing or erasing in white) to the paths array
                        paths.append(currentPath)
                        currentPath = DrawingPath(color: currentColor, points: []) // Start a new path
                        undonePaths.removeAll() // Clear undone paths after new stroke
                    }
            )
            .padding()

            // Control buttons (Clear, Undo, Redo)
            HStack {
                Button(action: {
                    paths.removeAll()
                    undonePaths.removeAll()
                }) {
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }

                Button(action: {
                    if let lastPath = paths.last {
                        undonePaths.append(lastPath)
                        paths.removeLast()
                    }
                }) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Button(action: {
                    if let lastUndonePath = undonePaths.last {
                        paths.append(lastUndonePath)
                        undonePaths.removeLast()
                    }
                }) {
                    Image(systemName: "arrow.uturn.forward")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle("Simple Drawing App")
    }
}

// Structure to store drawing paths with color and points
struct DrawingPath {
    var color: Color
    var points: [CGPoint]
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

