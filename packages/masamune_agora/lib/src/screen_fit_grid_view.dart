part of masamune_agora;

/// The grid is displayed in full screen up to a certain count and then scrolled.
class ScreenFitGridView extends StatelessWidget {
  /// The grid is displayed in full screen up to a certain count and then scrolled.
  const ScreenFitGridView({
    Key? key,
    required this.children,
  }) : super(key: key);

  /// Widget element.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const Empty();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final length = children.length;
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        if (width < height) {
          if (length > 8) {
            return SingleChildScrollView(
              child: Column(
                children: children.split(2).map(
                  (screens) {
                    return Row(
                      children: screens
                          .map(
                            (screen) => Expanded(
                              child: SizedBox(
                                height: height / 4,
                                child: screen,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ).toList(),
              ),
            );
          } else if (length > 3) {
            return Column(
              children: children.split(2).map(
                (screens) {
                  return Expanded(
                    child: Row(
                      children: screens
                          .map(
                            (screen) => Expanded(
                              child: SizedBox(
                                height: height / (length / 2).ceil(),
                                child: screen,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ).toList(),
            );
          } else {
            return Column(
              children: children.map(
                (screen) {
                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: height / length,
                            child: screen,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            );
          }
        } else {
          if (length > 8) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: children.split(2).map(
                  (screens) {
                    return Column(
                      children: screens
                          .map(
                            (screen) => Expanded(
                              child: SizedBox(
                                width: width / 4,
                                child: screen,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ).toList(),
              ),
            );
          } else if (length > 3) {
            return Row(
              children: children.split(2).map(
                (screens) {
                  return Expanded(
                    child: Column(
                      children: screens
                          .map(
                            (screen) => Expanded(
                              child: Container(
                                width: width / (length / 2).ceil(),
                                child: screen,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ).toList(),
            );
          } else {
            return Row(
              children: children.map(
                (screen) {
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: width / length,
                            child: screen,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            );
          }
        }
      },
    );
  }
}
