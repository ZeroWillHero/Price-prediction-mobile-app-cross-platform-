import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../l10n/gen/app_localizations.dart';
import '../models/dated_price.dart';
import '../theme/app_colors.dart';
import '../utils/price_formatters.dart';
import 'app_card.dart';

/// Lets a farmer look up the price for any date — past (recorded) or
/// future (predicted) — without needing to read a chart. Shows one big
/// number for the selected date, plus simple previous/next/pick-date
/// controls and a row of nearby dates to tap.
class PriceDateExplorer extends StatefulWidget {
  const PriceDateExplorer({
    super.key,
    required this.points,
    this.initialDate,
  });

  final List<DatedPrice> points;

  final DateTime? initialDate;

  @override
  State<PriceDateExplorer> createState() => _PriceDateExplorerState();
}

class _PriceDateExplorerState extends State<PriceDateExplorer> {
  late int _selectedIndex;
  final ScrollController _stripController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = _closestIndexTo(widget.initialDate ?? DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(covariant PriceDateExplorer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.points != widget.points) {
      _selectedIndex = _closestIndexTo(widget.initialDate ?? DateTime.now());
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  int _closestIndexTo(DateTime date) {
    if (widget.points.isEmpty) return 0;
    int closest = 0;
    Duration best = const Duration(days: 999999);
    for (int i = 0; i < widget.points.length; i += 1) {
      final Duration diff = widget.points[i].date.difference(date).abs();
      if (diff < best) {
        best = diff;
        closest = i;
      }
    }
    return closest;
  }

  void _select(int index) {
    if (index < 0 || index >= widget.points.length) return;
    setState(() => _selectedIndex = index);
    _scrollToSelected();
  }

  void _scrollToSelected() {
    if (!_stripController.hasClients) return;
    const double chipWidth = 72;
    final double target = (_selectedIndex * chipWidth) -
        (_stripController.position.viewportDimension / 2) +
        chipWidth / 2;
    _stripController.animateTo(
      target.clamp(0, _stripController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime first = widget.points.first.date;
    final DateTime last = widget.points.last.date;
    final DateTime picked = await showDatePicker(
          context: context,
          initialDate: widget.points[_selectedIndex].date,
          firstDate: first,
          lastDate: last,
        ) ??
        widget.points[_selectedIndex].date;
    _select(_closestIndexTo(picked));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations t = AppLocalizations.of(context);
    if (widget.points.isEmpty) {
      return const AppCard(
        padding: EdgeInsets.all(20),
        child: Text(
          'No price data yet.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    final DatedPrice selected = widget.points[_selectedIndex];
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppCard(
          variant: AppCardVariant.glow,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              _StatusPill(isPredicted: selected.isPredicted, t: t),
              const SizedBox(height: 10),
              Text(
                DateFormat('d MMM yyyy').format(selected.date),
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              Text(
                formatRs(selected.price),
                style: GoogleFonts.poppins(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            _NavButton(
              icon: Icons.chevron_left,
              onTap: () => _select(_selectedIndex - 1),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickDate(context),
                icon: const Icon(Icons.calendar_month, size: 18),
                label: Text(t.pickDate),
              ),
            ),
            const SizedBox(width: 8),
            _NavButton(
              icon: Icons.chevron_right,
              onTap: () => _select(_selectedIndex + 1),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 66,
          child: ListView.builder(
            controller: _stripController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.points.length,
            itemBuilder: (BuildContext context, int index) {
              final DatedPrice point = widget.points[index];
              final bool isSelected = index == _selectedIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _DateChip(
                  point: point,
                  isSelected: isSelected,
                  isDark: isDark,
                  onTap: () => _select(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isPredicted, required this.t});

  final bool isPredicted;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final Color color = isPredicted ? AppColors.amber : AppColors.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            isPredicted ? Icons.auto_awesome : Icons.check_circle,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            isPredicted ? t.aiPrediction : t.recordedPrice,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(width: 48, height: 48, child: Icon(icon)),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.point,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final DatedPrice point;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color accent = point.isPredicted ? AppColors.amber : AppColors.accent;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? accent.withValues(alpha: 0.16)
              : (isDark ? AppColors.surfaceSunk : AppColors.bgLight),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? accent : Theme.of(context).dividerColor,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              DateFormat('MMM').format(point.date),
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('d').format(point.date),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? accent : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
