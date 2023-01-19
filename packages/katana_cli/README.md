<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana CLI</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/twitter/follow/mathru.svg?colorA=1da1f2&colorB=&label=Follow%20on%20Twitter&style=flat-square" alt="Follow on Twitter" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://www.buymeacoffee.com/mathru"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=mathru&button_colour=FF5F5F&font_colour=ffffff&font_family=Poppins&outline_colour=000000&coffee_colour=FFDD00" width="136" /></a>
</p>

---

[[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/)

---

Command line interface used in the [Masamune framework](https://pub.dev/packages/masamune).

The following features are available

- Project creation and optimization against the Masamune framework
- Code template generation
- Automatic code generation with [build_runner](https://pub.dev/packages/build_runner)
- Other settings

# Installation

Install with the following command.

```bash
flutter pub global activate katana
```

# How to use

The following commands are available

```bash
katana [command] [subcommand] [optional parameters]
```

Help for the command is available at

```bash
katana help
```

## Project Creation

Execute the following command in the folder where the project was created.

The `Application ID` should include the ID in the reverse domain (com.test.myapplication).

```bash
katana create [Application ID(e.g. com.test.myapplication)]
```

## Code generation

The following commands can be used to generate each code template.

```bash
katana code [Code ID] [Optional Parameters]
```

### Page

Create page templates under `lib/pages`.

```bash
katana code page [PageName]
```

### Collection Model

Create a collection model under `lib/models`.

```bash
katana code collection [ModelName]
```

### Document Model

Create a document model under `lib/models`.

```bash
katana code document [ModelName]
```

### Controller

Create controllers under `lib/controllers`.

```bash
katana code controller [ControllerName]
```

For other codes, please see Help.

## Automatic code generation with build_runner

You must have build_runner installed in your project in order to run it.

```bash
flutter pub add --dev build_runner
```

### Automatic code generation

If you want to perform automatic code generation as a one-shot, execute the following command.

```bash
katana code generate
```

### Code generation monitoring

If you want to monitor code changes and automatically generate code when changes are made, execute the following command.

```bash
katana code watch
```

For other commands, please see Help.
