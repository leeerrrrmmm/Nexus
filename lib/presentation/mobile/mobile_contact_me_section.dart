import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/const/app_assets/app_assets.dart';
import 'package:portfolio/core/const/app_text/app_text.dart';
import 'package:portfolio/core/links/portfolio_link.dart';
import 'package:portfolio/core/links/portfolio_link_scope.dart';
import 'package:portfolio/features/contact/domain/entity/contact_me_entity.dart';
import 'package:portfolio/features/state/cubit/contact_me_cubit.dart';
import 'package:portfolio/presentation/form/contact_me_form.dart';
import 'package:portfolio/presentation/widgets/adaptive_letter_spacing_field.dart';
import 'package:portfolio/presentation/widgets/glass_text.dart';

class MobileContactMeSection extends StatefulWidget {
  const MobileContactMeSection({super.key});

  @override
  State<MobileContactMeSection> createState() => _MobileContactMeSectionState();
}

class _MobileContactMeSectionState extends State<MobileContactMeSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  late final AdaptiveInputTypography _nameSpacing;
  late final AdaptiveInputTypography _emailSpacing;
  late final AdaptiveInputTypography _messageSpacing;
  bool isHovered = false;

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
            minHeight: 0.75.sh,
            maxHeight: 1.sh,
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0.h,
                right: 0,
                child: Image.asset(AppAssets.contactMeBg, scale: 2),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50.h, left: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GlassText(
                        text: AppText.contactMeTitle,
                        fontSize: 55.sp,
                        fontFamily: 'Kokh',
                      ),
                      SizedBox(height: 40.h),
                      _ContactMeForm(
                        fullNameController: fullNameController,
                        emailController: emailController,
                        messageController: messageController,
                        nameSpacing: _nameSpacing,
                        emailSpacing: _emailSpacing,
                        messageSpacing: _messageSpacing,
                        readSnapshot: _readSnapshot,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          MouseRegion(
                            onEnter: (event) =>
                                setState(() => isHovered = true),
                            onExit: (event) =>
                                setState(() => isHovered = false),
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () => _handleSubmit(context),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                key: const Key('submit_button'),
                                width: 160.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                  color: isHovered
                                      ? const Color(
                                          0xFFC3C3C3,
                                        ).withValues(alpha: 0.42)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: const Color(
                                      0xFFC3C3C3,
                                    ).withValues(alpha: 0.42),
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                  child: isLoading
                                      ? SizedBox(
                                          width: 18.w,
                                          height: 18.w,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                        )
                                      : Text(
                                          'SUBMIT',
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontFamily: 'Kosugi',
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: _socialLinks.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 0 : 10.w,
                                ),
                                child: _SocialCircleButton(
                                  icon: item.icon,
                                  color: Colors.white,
                                  onTap: () =>
                                      PortfolioLinkScope.of(context)(item.link),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Positioned(
              //   bottom: 0.h,
              //   right: 0,
              //   child: Image.asset(AppAssets.contactMeBg, scale: 2),
              // ),
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
          scale: _isHovered ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: Colors.white.withValues(alpha: _isHovered ? 0.75 : 0.4),
                width: _isHovered ? 1.8.w : 1.2.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: _isHovered ? 12 : 8,
                  spreadRadius: _isHovered ? 2 : 1,
                ),
                if (_isHovered)
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 14,
                    spreadRadius: -6,
                  ),
              ],
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                color: widget.color,
                size: _isHovered ? 18.sp : 16.sp,
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
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _ContactMeTextFieldWidget(
          controller: fullNameController,
          spacingController: nameSpacing,
          label: AppText.fullName,
          fieldWidth: 180.8.w,
          fieldHeight: 41.73.h,
          validator: contactMeFormAdapter.fieldValidator('name', readSnapshot),
        ),
        _ContactMeTextFieldWidget(
          controller: emailController,
          spacingController: emailSpacing,
          label: AppText.email,
          fieldWidth: 180.8.w,
          fieldHeight: 41.73.h,
          validator: contactMeFormAdapter.fieldValidator('email', readSnapshot),
        ),
        _ContactMeTextFieldWidget(
          controller: messageController,
          spacingController: messageSpacing,
          label: AppText.message,
          fieldWidth: 260.8.w,
          fieldHeight: 120.h,
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
            fontSize: 20.sp,
            fontFamily: 'Kosugi',
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: fieldWidth,
          child: ListenableBuilder(
            listenable: spacingController,
            builder: (context, _) {
              return TextFormField(
                cursorColor: Colors.white,
                cursorHeight: 20.h,
                keyboardType: label == AppText.email
                    ? TextInputType.emailAddress
                    : TextInputType.text,
                key: Key(label.toLowerCase()),
                controller: controller,
                maxLines: isMultiline ? 8 : 1,
                minLines: isMultiline ? 4 : 1,
                textAlignVertical: isMultiline
                    ? TextAlignVertical.top
                    : TextAlignVertical.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: spacingController.fontFamily,
                  color: Colors.white,
                ),
                validator: validator,
                decoration: InputDecoration(
                  constraints: BoxConstraints(minHeight: fieldHeight),
                  errorStyle: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'Kosugi',
                    color: Colors.redAccent.shade100,
                    height: 1.2,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent.shade100),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent.shade100),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: isMultiline ? 8.h : 10.h,
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
