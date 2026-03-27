class ScanModel {
  final String id;
  final String url;
  final String verdict;
  final double confidence;
  final String riskLevel;
  final DateTime scannedAt;
  final List<String> threats;

  ScanModel({
    required this.id,
    required this.url,
    required this.verdict,
    required this.confidence,
    required this.riskLevel,
    required this.scannedAt,
    required this.threats,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';
    final labelRaw = json['label'] ?? json['verdict'];
    final label = labelRaw?.toString() ?? 'unknown';
    final riskRaw = json['risk_level'] ?? json['riskLevel'];
    final riskLevel = (riskRaw?.toString() ?? 'unknown').toLowerCase();

    var confidence = (json['confidence'] as num?)?.toDouble() ?? 0.0;
    if (confidence > 1.0) {
      confidence = confidence / 100.0;
    }
    confidence = confidence.clamp(0.0, 1.0);

    final id = json['id']?.toString() ?? url.hashCode.toString();
    final scannedAt = json['scanned_at'] != null
        ? DateTime.tryParse(json['scanned_at'].toString()) ?? DateTime.now()
        : DateTime.now();

    final threats = json['threats'] != null
        ? List<String>.from(json['threats'] as List)
        : <String>[];

    return ScanModel(
      id: id,
      url: url,
      verdict: _labelToVerdict(label),
      confidence: confidence,
      riskLevel: riskLevel,
      scannedAt: scannedAt,
      threats: threats,
    );
  }

  static String _labelToVerdict(String label) {
    final l = label.toLowerCase().trim();
    if (l == 'safe' ||
        l == 'benign' ||
        l == 'legitimate' ||
        l.contains('safe')) {
      return 'safe';
    }
    if (l == 'suspicious' || l.contains('suspicious')) {
      return 'suspicious';
    }
    if (l.contains('phish') ||
        l.contains('malicious') ||
        l == 'dangerous' ||
        l.contains('malware')) {
      return 'dangerous';
    }
    return label;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'verdict': verdict,
      'confidence': confidence,
      'risk_level': riskLevel,
      'scanned_at': scannedAt.toIso8601String(),
      'threats': threats,
    };
  }
}
