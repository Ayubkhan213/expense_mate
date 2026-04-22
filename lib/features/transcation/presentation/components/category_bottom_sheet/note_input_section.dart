import 'dart:io';
import 'package:flutter/material.dart';
import 'package:spendio/core/app_export.dart';
import 'package:spendio/core/theme/typography/app_text_styles.dart';
import 'package:spendio/l10n/app_localizations.dart';

// =============================================================================
// NoteInputField
// Note text field + selected image thumbnail preview below it
// =============================================================================
class NoteInputField extends StatefulWidget {
  final String note;
  final File? selectedImage; // pass state.selectedImage
  final Function(String) onNoteChanged;
  final VoidCallback onImagePick; // gallery
  final VoidCallback onCameraCapture; // camera
  final VoidCallback? onImageRemove; // optional: clear image

  const NoteInputField({
    super.key,
    required this.note,
    required this.onNoteChanged,
    required this.onImagePick,
    required this.onCameraCapture,
    this.selectedImage,
    this.onImageRemove,
  });

  @override
  State<NoteInputField> createState() => _NoteInputFieldState();
}

class _NoteInputFieldState extends State<NoteInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openSheet(AppLocalizations t) {
    ImagePickerSheet.show(
      context,
      onGallery: widget.onImagePick,
      onCamera: widget.onCameraCapture,
      hasImage: widget.selectedImage != null,
      onRemove: widget.onImageRemove,
      t: t,
      title: t.addPhoto,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final isRTL = locale.languageCode == 'ar' || locale.languageCode == 'ur';
    final hasImage = widget.selectedImage != null;
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Text field ──────────────────────────────────────────────────
        TextField(
          controller: _controller,
          onChanged: widget.onNoteChanged,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            hintText: t.addANote,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 14,
            ),
            filled: true,
            fillColor: isDark ? colorScheme.surface : Colors.grey[100],
            // Attach button at the right
            suffixIcon: GestureDetector(
              onTap: () {
                _openSheet(t);
              },
              child: Container(
                margin: const EdgeInsets.all(6),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: hasImage
                      ? colorScheme.primary.withValues(alpha: 0.12)
                      : colorScheme.onSurface.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: hasImage
                      ? Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.35),
                        )
                      : null,
                ),
                child: Icon(
                  hasImage ? Icons.attach_file_rounded : Icons.image_outlined,
                  size: 18,
                  color: hasImage
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),

        // ── Image preview thumbnail ─────────────────────────────────────
        if (hasImage) ...[
          const SizedBox(height: 8),
          _ImagePreviewTile(
            file: widget.selectedImage!,
            primary: colorScheme.primary,
            isDark: isDark,
            onRemove: widget.onImageRemove,
            onTap: () {
              _openSheet(t);
            },
          ),
        ],
      ],
    );
  }
}

// =============================================================================
// _ImagePreviewTile
// Compact horizontal tile showing the selected image thumbnail
// =============================================================================
class _ImagePreviewTile extends StatelessWidget {
  final File file;
  final Color primary;
  final bool isDark;
  final VoidCallback? onRemove;
  final VoidCallback onTap;

  const _ImagePreviewTile({
    required this.file,
    required this.primary,
    required this.isDark,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark
              ? primary.withValues(alpha: 0.08)
              : primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(file, width: 48, height: 48, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),

            // File name + label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.attachment,
                    style: TextStyle(
                      color: primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    file.path.split('/').last,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Change button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                t.change,
                style: TextStyle(
                  color: primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 6),

            // Remove X
            if (onRemove != null)
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ImagePickerSheet
// Reusable premium bottom sheet for camera / gallery / remove
// Use in both EditProfileFace and NoteInputField
// =============================================================================
class ImagePickerSheet {
  static void show(
    BuildContext context, {
    required VoidCallback onGallery,
    required VoidCallback onCamera,
    bool hasImage = false,
    required AppLocalizations t,
    VoidCallback? onRemove,
    String title = 'Add Photo',
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,

      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 32,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Drag handle ───────────────────────────────────────
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 22),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // ── Title row ─────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(
                          Icons.add_photo_alternate_rounded,
                          color: primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.h6.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            t.chooseSource,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ── Two option cards ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _PickerOptionCard(
                          icon: Icons.camera_alt_rounded,
                          label: t.camera,
                          sublabel: t.takePhoto,
                          primary: primary,
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(ctx);
                            onCamera();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PickerOptionCard(
                          icon: Icons.photo_library_rounded,
                          label: t.gallery,
                          sublabel: t.chooseFromLibrary,
                          primary: primary,
                          isDark: isDark,
                          onTap: () {
                            Navigator.pop(ctx);
                            onGallery();
                          },
                        ),
                      ),
                    ],
                  ),

                  // ── Remove option (only if image exists) ──────────────
                  if (hasImage && onRemove != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.15),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(ctx);
                          onRemove();
                        },
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                        title: Text(
                          t.removePhoto,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          t.deleteCurrentAttachment,
                          style: TextStyle(
                            color: Colors.red.withValues(alpha: 0.6),
                            fontSize: 11,
                          ),
                        ),
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        minLeadingWidth: 0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// _PickerOptionCard
// The camera / gallery card inside ImagePickerSheet
// =============================================================================
class _PickerOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color primary;
  final bool isDark;
  final VoidCallback onTap;

  const _PickerOptionCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.primary,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark
              ? primary.withValues(alpha: 0.1)
              : primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary.withValues(alpha: 0.18)),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: primary, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              sublabel,
              style: TextStyle(
                color: primary.withValues(alpha: 0.55),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
