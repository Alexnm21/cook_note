part of '../view/recipe_form.dart';

class MacrosFormPart extends StatefulWidget {
  final Map<Macros, double>? macros;
  final Function(Map<Macros, double>) onChanged;
  final List<Ingredient> ingredients;
  final int portions;

  const MacrosFormPart({
    super.key,
    this.macros,
    required this.onChanged,
    required this.ingredients,
    this.portions = 1,
  });

  @override
  State<MacrosFormPart> createState() => _MacrosFormPartState();
}

class _MacrosFormPartState extends State<MacrosFormPart> {
  bool _isCalculating = false;

  Future<void> _calculateMacrosWithAI() async {
    if (widget.ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega ingredientes antes de calcular los macros'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isCalculating = true;
    });

    try {
      final service = MacrosAIService();
      final calculatedMacros = await service.calculateMacros(
        widget.ingredients,
        portions: widget.portions,
      );

      widget.onChanged(calculatedMacros);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: AwesomeSnackbarContent(
              title: 'macros.success_calculate_with_ai'.tr(),
              message: 'macros.success_calculate_with_ai'.tr(),
              contentType: ContentType.success,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('macros.error_calculate_with_ai'.tr(args: [e.toString()])),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCalculating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final bool showLabel = constraints.maxWidth > 350;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('recipe_form.macros'.tr(), style: baseTextStyle.h2),
                showLabel
                    ? ElevatedButton.icon(
                        onPressed:
                            _isCalculating ? null : _calculateMacrosWithAI,
                        icon: _isCalculating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome, size: 18),
                        label: Text(_isCalculating
                            ? 'Calculando...'
                            : 'Calcular con IA'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      )
                    : ElevatedButton(
                        onPressed:
                            _isCalculating ? null : _calculateMacrosWithAI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                          minimumSize: const Size(48, 48),
                        ),
                        child: _isCalculating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.auto_awesome, size: 18),
                      ),
              ],
            );
          },
        ),
        spacings.y.s10,
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.8,
          children: Macros.values
              .map(
                (macro) => _MacroInputField(
                  macro: macro,
                  value: widget.macros?[macro] ?? 0.0,
                  onChanged: (value) {
                    final updatedMacros =
                        Map<Macros, double>.from(widget.macros ?? {});
                    updatedMacros[macro] = value;
                    widget.onChanged(updatedMacros);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _MacroInputField extends StatefulWidget {
  final Macros macro;
  final double value;
  final Function(double) onChanged;

  const _MacroInputField({
    required this.macro,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_MacroInputField> createState() => _MacroInputFieldState();
}

class _MacroInputFieldState extends State<_MacroInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value > 0 ? widget.value.toString() : '',
    );
  }

  @override
  void didUpdateWidget(_MacroInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualizar el controller solo si el valor cambió desde fuera
    // (por ejemplo, cuando se calcula con IA)
    if (oldWidget.value != widget.value) {
      final newText = widget.value > 0 ? widget.value.toString() : '';
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.macro.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.macro.color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.macro.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              widget.macro.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.macro.text,
                  style: baseTextStyle.h3.copyWith(
                    color: widget.macro.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _getUnit(widget.macro),
                  style: baseTextStyle.body.copyWith(
                    color: widget.macro.color.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              style: baseTextStyle.h3.copyWith(
                color: widget.macro.color,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: baseTextStyle.h3.copyWith(
                  color: widget.macro.color.withValues(alpha: 0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.macro.color.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.macro.color.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.macro.color,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                final numericValue = double.tryParse(value) ?? 0.0;
                widget.onChanged(numericValue);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getUnit(Macros macro) {
    switch (macro) {
      case Macros.calories:
        return 'kcal';
      case Macros.protein:
      case Macros.carbs:
      case Macros.fat:
        return 'g';
    }
  }
}
