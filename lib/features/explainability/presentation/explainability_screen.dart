import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/state/app_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/price_formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/segmented_tab.dart';

class ExplainabilityScreen extends StatefulWidget {
  const ExplainabilityScreen({super.key});

  @override
  State<ExplainabilityScreen> createState() => _ExplainabilityScreenState();
}

class _ExplainabilityScreenState extends State<ExplainabilityScreen> {
  String _lang = 'EN';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    final forecast = controller.repository.forecastFor(
      controller.selectedVegetable.name,
      controller.selectedHorizon,
    );
    final layers = controller.repository.explainabilityLayers;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bg : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'How it works',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: isDark ? AppColors.text : const Color(0xFF0F1F17),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        children: <Widget>[
          // Title
          Column(
            children: <Widget>[
              Text(
                '3 layers, one prediction',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.text : const Color(0xFF0F1F17),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'How AgriPredict turns data into a price you can trust.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // Layer cards
          ...layers.asMap().entries.expand(
                (entry) => <Widget>[
                  _LayerCard(
                    index: entry.key,
                    layer: entry.value,
                    lang: _lang,
                  ),
                  if (entry.key < layers.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 22,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 22,
                color: AppColors.textMuted,
              ),
            ),
          ),

          // Final prediction fire card
          AppCard(
            variant: AppCardVariant.fire,
            padding: const EdgeInsets.all(22),
            radius: 24,
            child: Column(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0x40FFFFFF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.auto_awesome,
                          size: 14, color: Color(0xFF06180E)),
                      const SizedBox(width: 5),
                      Text(
                        _lang == 'සිං' ? 'ඔබගේ අනාවැකිය' : 'Your prediction',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF06180E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  formatRs(forecast.predictedPrice),
                  style: GoogleFonts.poppins(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF06150C),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '80% confidence · ${controller.selectedHorizon} ahead',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF06180E),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LayerCard extends StatelessWidget {
  const _LayerCard({
    required this.index,
    required this.layer,
    required this.lang,
  });

  final int index;
  final dynamic layer;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.outline : AppColors.outlineLight,
        ),
        // Left accent border
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Left color accent
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: layer.color,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Icon circle
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: (layer.color as Color).withOpacity(0.14),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: (layer.color as Color).withOpacity(0.24),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Icon(layer.icon, color: layer.color, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Layer ${index + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: layer.color,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang == 'සිං' ? layer.titleSi : layer.titleEn,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: isDark
                                  ? AppColors.text
                                  : const Color(0xFF0F1F17),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            layer.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
