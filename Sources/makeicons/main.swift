/**
 Check parameters and call main application functions.
 */

let arguments = CommandLine.arguments
if arguments.count < 3 {
    Application.shared.printHelp()
} else {
    let imagePath = arguments[1]
    let projectPath = arguments[2]
    let idiom = arguments.count >= 5 ? arguments[4] : nil
    Application.shared.run(imagePath: imagePath, projectPath: projectPath, idiom: idiom)
}
