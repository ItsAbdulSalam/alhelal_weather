import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  const int size = 1024;
  final image = img.Image(width: size, height: size);

  // 1. رسم خلفية بتدرج لوني أزرق ملكي عميق (Gradient)
  for (int y = 0; y < size; y++) {
    final double t = y / size;
    final int r = (0x10 + (0x1E - 0x10) * t).round();
    final int g = (0x1F + (0x3C - 0x1F) * t).round();
    final int b = (0x3A + (0x72 - 0x3A) * t).round();
    for (int x = 0; x < size; x++) {
      image.setPixelRgba(x, y, r, g, b, 255);
    }
  }

  // 2. رسم توهج الشمس الذهبية (Glowing Sun)
  const int sunCenterX = 600;
  const int sunCenterY = 420;
  const int sunRadius = 170;

  for (
    int y = sunCenterY - sunRadius - 80;
    y <= sunCenterY + sunRadius + 80;
    y++
  ) {
    for (
      int x = sunCenterX - sunRadius - 80;
      x <= sunCenterX + sunRadius + 80;
      x++
    ) {
      if (x < 0 || x >= size || y < 0 || y >= size) continue;
      final double dx = (x - sunCenterX).toDouble();
      final double dy = (y - sunCenterY).toDouble();
      final double dist = (dx * dx + dy * dy);

      if (dist <= sunRadius * sunRadius) {
        // قرص الشمس الذهبي
        image.setPixelRgba(x, y, 255, 193, 7, 255);
      } else if (dist <= (sunRadius + 70) * (sunRadius + 70)) {
        // توهج الشمس اللطيف
        final double glow =
            1.0 -
            ((dist - sunRadius * sunRadius) /
                ((sunRadius + 70) * (sunRadius + 70) - sunRadius * sunRadius));
        final currentPixel = image.getPixel(x, y);
        final int r = (currentPixel.r + (255 - currentPixel.r) * (glow * 0.45))
            .round()
            .clamp(0, 255);
        final int g = (currentPixel.g + (213 - currentPixel.g) * (glow * 0.45))
            .round()
            .clamp(0, 255);
        final int b = (currentPixel.b + (79 - currentPixel.b) * (glow * 0.45))
            .round()
            .clamp(0, 255);
        image.setPixelRgba(x, y, r, g, b, 255);
      }
    }
  }

  // 3. رسم الغيمة الزجاجية شبه الشفافة (Frosted Glass Cloud)
  final cloudCircles = [
    [380, 580, 150], // الدائرة اليسرى
    [520, 520, 180], // الدائرة الوسطى المرتفعة
    [660, 590, 140], // الدائرة اليمنى
    [480, 640, 150], // قاعدة الغيمة
  ];

  for (final circle in cloudCircles) {
    final int cx = circle[0];
    final int cy = circle[1];
    final int rad = circle[2];

    for (int y = cy - rad; y <= cy + rad; y++) {
      for (int x = cx - rad; x <= cx + rad; x++) {
        if (x < 0 || x >= size || y < 0 || y >= size) continue;
        final double dx = (x - cx).toDouble();
        final double dy = (y - cy).toDouble();
        if (dx * dx + dy * dy <= rad * rad) {
          final currentPixel = image.getPixel(x, y);
          // دمج لون أبيض نصف شفاف (Glass effect)
          final int r = (currentPixel.r * 0.25 + 255 * 0.75).round();
          final int g = (currentPixel.g * 0.25 + 255 * 0.75).round();
          final int b = (currentPixel.b * 0.25 + 255 * 0.75).round();
          image.setPixelRgba(x, y, r, g, b, 255);
        }
      }
    }
  }

  // التأكد من وجود المجلد
  final directory = Directory('assets/icon');
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  // حفظ الصورة بجودة PNG كاملة 1024x1024
  final pngBytes = img.encodePng(image);
  File('assets/icon/app_icon.png').writeAsBytesSync(pngBytes);
  print(
    '✅ تم إنشاء وحفظ الأيقونة بأبعاد 1024x1024 بنجاح في: assets/icon/app_icon.png',
  );
}
