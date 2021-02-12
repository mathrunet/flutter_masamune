part of masamune;

class Space extends SizedBox {
  const Space({double width = 8, double height = 8})
      : super(width: width, height: height);
  const Space.width([double value = 8]) : super(width: value);
  const Space.height([double value = 8]) : super(height: value);
}
