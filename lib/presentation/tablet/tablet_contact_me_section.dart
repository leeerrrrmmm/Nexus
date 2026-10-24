import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/const/app_assets/asset_image_cache.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/core/links/portfolio_link_scope.dart';
import 'package:portfolio/features/contact/domain/entity/contact_me_entity.dart';
import 'package:portfolio/features/state/cubit/contact_me_cubit.dart';
import 'package:portfolio/presentation/form/contact_me_form.dart';
import 'package:portfolio/presentation/widgets/adaptive_letter_spacing_field.dart';
import 'package:portfolio/presentation/widgets/glass_text.dart';

class TabletContactMeSection extends StatefulWidget {
  const TabletContactMeSection({super.key});

  @override
  State<TabletContactMeSection> createState() => _TabletContactMeSectionState();
}

class _TabletContactMeSectionState extends State<TabletContactMeSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  late final AdaptiveInputTypography _nameSpacing;
  late final AdaptiveInputTypography _emailSpacing;
  late final AdaptiveInputTypography _messageSpacing;
  bool isHoveredSubmit = false;

  static const _socialLinks = <({FaIconData icon, PortfolioLink link})>[
    (icon: FontAwesomeIcons.github, link: PortfolioLink.githubProfile),
    (icon: FontAwesomeIcons.telegram, link: PortfolioLink.telegram),
    (icon: FontAwesomeIcons.instagram, link: PortfolioLink.instagram),
    (icon: FontAwesomeIcons.linkedin, link: PortfolioLink.linkedIn),
  ];

  Map<String, dynamic> _readSnapshot() => {
    'name': fullNameController.text,
    'email': emailController.text,
    'message': messageController.text,
  };

  @override
  void initState() {
    super.initState();
    _nameSpacing = AdaptiveInputTypography(textController: fullNameController);
    _emailSpacing = AdaptiveInputTypography(textController: emailController);
    _messageSpacing = AdaptiveInputTypography(
      textController: messageController,
    );
  }

  void _handleSubmit(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    context.read<ContactMeCubit>().submit(
      ContactMeEntity(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        message: messageController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactMeCubit, ContactMeState>(
      listener: (context, state) {
        if (state is ContactMeSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message sent successfully!')),
          );
          _formKey.currentState?.reset();
          fullNameController.clear();
          emailController.clear();
          messageController.clear();
          context.read<ContactMeCubit>().reset();
        } else if (state is ContactMeFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is ContactMeLoading;

        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: 0.82.sh,
            maxHeight: 1.05.sh,
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 70.h, left: 50.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GlassText(
                        text: AppText.contactMeTitle,
                        fontSize: 68.sp,
                        fontFamily: 'Kokh',
                      ),
                      SizedBox(height: 50.h),
                      _ContactMeForm(
                        fullNameController: fullNameController,
                        emailController: emailController,
                        messageController: messageController,
                        nameSpacing: _nameSpacing,
                        emailSpacing: _emailSpacing,
                        messageSpacing: _messageSpacing,
                        readSnapshot: _readSnapshot,
                      ),
                      SizedBox(height: 40.h),
                      MouseRegion(
                        onEnter: (_) => setState(() => isHoveredSubmit = true),
                        onExit: (_) => setState(() => isHoveredSubmit = false),
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: isLoading
                              ? null
                              : () => _handleSubmit(context),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 210.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: isHoveredSubmit
                                  ? const Color(
                                      0xFFC3C3C3,
                                    ).withValues(alpha: 0.45)
                                  : Colors.transparent,
                              border: Border.all(
                                color: const Color(
                                  0xFFC3C3C3,
                                ).withValues(alpha: 0.55),
                                width: 1.5.w,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: isLoading
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'SUBMIT',
                                      style: TextStyle(
                                        fontSize: 23.sp,
                                        fontFamily: 'Kosugi',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -30.h,
                right: 0.w,
                child: Image.asset(
                  AppAssets.contactMeBg,
                  scale: 1.35,
                  cacheWidth: AssetImageCache.cacheWidth(
                    context,
                    AppAssets.contactMeBg,
                  ),
                ),
              ),
              Positioned(
                bottom: 60.h,
                right: 60.w,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _socialLinks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 0 : 18.w),
                      child: _SocialCircleButton(
                        icon: item.icon,
                        color: Colors.white,
                        onTap: () => PortfolioLinkScope.of(context)(item.link),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameSpacing.dispose();
    _emailSpacing.dispose();
    _messageSpacing.dispose();
    fullNameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }
}

class _SocialCircleButton extends StatefulWidget {
  final FaIconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialCircleButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_SocialCircleButton> createState() => _SocialCircleButtonState();
}

class _SocialCircleButtonState extends State<_SocialCircleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.18 : 1.0,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: 62.r,
            height: 62.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: Colors.white.withValues(alpha: _isHovered ? 0.75 : 0.4),
                width: _isHovered ? 2.2.w : 1.5.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: _isHovered ? 18 : 12,
                  spreadRadius: _isHovered ? 4 : 2,
                ),
                if (_isHovered)
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: -8,
                  ),
              ],
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                color: widget.color,
                size: _isHovered ? 31.sp : 28.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactMeForm extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final AdaptiveInputTypography nameSpacing;
  final AdaptiveInputTypography emailSpacing;
  final AdaptiveInputTypography messageSpacing;
  final Map<String, dynamic> Function() readSnapshot;

  const _ContactMeForm({
    required this.fullNameController,
    required this.emailController,
    required this.messageController,
    required this.nameSpacing,
    required this.emailSpacing,
    required this.messageSpacing,
    required this.readSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 18.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _ContactMeTextFieldWidget(
          controller: fullNameController,
          spacingController: nameSpacing,
          label: AppText.fullName,
          fieldWidth: 260.w,
          fieldHeight: 52.h,
          validator: contactMeFormAdapter.fieldValidator('name', readSnapshot),
        ),
        _ContactMeTextFieldWidget(
          controller: emailController,
          spacingController: emailSpacing,
          label: AppText.email,
          fieldWidth: 260.w,
          fieldHeight: 52.h,
          validator: contactMeFormAdapter.fieldValidator('email', readSnapshot),
        ),
        _ContactMeTextFieldWidget(
          controller: messageController,
          spacingController: messageSpacing,
          label: AppText.message,
          fieldWidth: 340.w,
          fieldHeight: 145.h,
          isMultiline: true,
          validator: contactMeFormAdapter.fieldValidator(
            'message',
            readSnapshot,
          ),
        ),
      ],
    );
  }
}

class _ContactMeTextFieldWidget extends StatelessWidget {
  const _ContactMeTextFieldWidget({
    required this.controller,
    required this.spacingController,
    required this.label,
    required this.fieldWidth,
    required this.fieldHeight,
    required this.validator,
    this.isMultiline = false,
  });

  final TextEditingController controller;
  final AdaptiveInputTypography spacingController;
  final String label;
  final double fieldWidth;
  final double fieldHeight;
  final bool isMultiline;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 21.sp,
            fontFamily: 'Kosugi',
            color: Colors.white,
            letterSpacing: 0.4,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: fieldWidth,
          child: ListenableBuilder(
            listenable: spacingController,
            builder: (context, _) {
              return TextFormField(
                cursorColor: Colors.white,
                cursorHeight: 22.h,
                keyboardType: label == AppText.email
                    ? TextInputType.emailAddress
                    : TextInputType.text,
                controller: controller,
                maxLines: isMultiline ? 8 : 1,
                minLines: isMultiline ? 5 : 1,
                textAlignVertical: isMultiline
                    ? TextAlignVertical.top
                    : TextAlignVertical.center,
                style: TextStyle(
                  fontSize: 19.sp,
                  fontFamily: spacingController.fontFamily,
                  color: Colors.white,
                ),
                validator: validator,
                decoration: InputDecoration(
                  constraints: BoxConstraints(minHeight: fieldHeight),
                  errorStyle: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: 'Kosugi',
                    color: Colors.redAccent.shade100,
                    height: 1.2,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent.shade100),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent.shade100),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: isMultiline ? 14.h : 12.h,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
