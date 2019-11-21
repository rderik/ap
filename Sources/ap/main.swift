import Foundation // For EXIT_SUCCESS
import Basic      // For Basic.stdoutStream
import SPMUtility

do {
  let parser = ArgumentParser(commandName: "ap",
                         usage: "ap",
                         overview: "The command is used for argument parsing",
                         seeAlso: "getopt(1)")

  let input = parser.add(option: "--input",
                         shortName: "-i",
                         kind: String.self,
                         usage: "A filename containing words",
                         completion: .filename)

  let generateBashCompletion = parser.add(option: "--generate-bash-completion",
                         shortName: "-g",
                         kind: Bool.self,
                         usage: "Generates bash completion script",
                         completion: ShellCompletion.none)


  let message = parser.add(positional: "message",
                         kind: String.self,
                         optional: true,
                         usage: "This is what the message should say",
                         completion: ShellCompletion.none)

  let names = parser.add(option: "--names",
                         shortName: "-n",
                         kind: [String].self,
                         strategy: .oneByOne,
                         usage: "Multiple names",
                         completion: ShellCompletion.none)

  let lastNames = parser.add(option: "--last-names",
                         shortName: "-l",
                         kind: String.self,
                         usage: "List of last names",
                         completion: ShellCompletion.values([
                            ("Ramirez","Like the dev Derik Ramirez"),
                            ("Garcia", "Like the writer Gabriel Garcia Marquez"),
                            ("Allende", "Like the Writer Isabel Allende")]))


  let argsv = Array(CommandLine.arguments.dropFirst())
  let parguments = try parser.parse(argsv)

  if let generate = parguments.get(generateBashCompletion), generate {
    let stdoutStream = Basic.stdoutStream
    stdoutStream <<< """
    #!/bin/bash

    _ap_wrapper()
    {
      declare -a cur prev
      cur=\"${COMP_WORDS[COMP_CWORD]}\"
      prev=\"${COMP_WORDS[COMP_CWORD-1]}\"
      COMPREPLY=()
      _ap
    }

    """
    parser.generateCompletionScript(for: .bash, on: stdoutStream)
    stdoutStream <<< """
    complete -F _ap_wrapper ap
    """
    stdoutStream.flush()
    exit(EXIT_SUCCESS)
  }

  if let filename = parguments.get(input) {
    print("Using filename: \(filename)")
  }

  if let message = parguments.get(message) {
    print("Using message: \(message)")
  }

  if let multipleNames = parguments.get(names) {
    print("Using names: \(multipleNames)")
  }

  if let multipleLastNames = parguments.get(lastNames) {
    print("Using last names: \(multipleLastNames)")
  }

} catch ArgumentParserError.expectedValue(let value) {
    print("Missing value for argument \(value).")
} catch ArgumentParserError.expectedArguments(let parser, let stringArray) {
    print("Parser: \(parser) Missing arguments: \(stringArray.joined()).")
} catch {
    print(error.localizedDescription)
}
