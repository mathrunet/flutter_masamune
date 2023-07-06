<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Katana CLI</h1>
</p>

<p align="center">
  <a href="https://twitter.com/mathru">
    <img src="https://img.shields.io/static/v1?label=Twitter&message=Follow&logo=Twitter&color=1DA1F2&link=https://twitter.com/mathru" alt="Follow on Twitter" />
  </a>
  <a href="https://threads.net/@mathrunet">
    <img src="https://img.shields.io/static/v1?label=Threads&message=Follow&color=101010&link=https://threads.net/@mathrunet" alt="Follow on Threads" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[Twitter]](https://twitter.com/mathru) | [[Threads]](https://threads.net/@mathrunet) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

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
flutter pub global activate katana_cli
```

Check the dependencies of the commands used internally. If these do not all pass, it may not work properly.

```bash
katana doctor
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
