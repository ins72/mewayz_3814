
import '../../../core/app_export.dart';

class BatchGenerationWidget extends StatefulWidget {
  final Function(List<String>) onBatchGenerate;

  const BatchGenerationWidget({
    super.key,
    required this.onBatchGenerate,
  });

  @override
  State<BatchGenerationWidget> createState() => _BatchGenerationWidgetState();
}

class _BatchGenerationWidgetState extends State<BatchGenerationWidget> {
  final TextEditingController _csvController = TextEditingController();
  List<String> urlList = [];
  bool isProcessing = false;

  @override
  void dispose() {
    _csvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        
        border: Border.all(
          color: AppTheme.border,
          width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Batch Generation',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
              Icon(
                Icons.batch_prediction_rounded,
                color: AppTheme.accent,
                size: 20.sp),
            ]),
          SizedBox(height: 16.h),
          Text(
            'Generate multiple QR codes from CSV input or URL list',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.secondaryText)),
          SizedBox(height: 16.h),
          
          // CSV Input
          TextFormField(
            controller: _csvController,
            maxLines: 5,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: AppTheme.primaryText),
            decoration: InputDecoration(
              hintText: 'Enter URLs (one per line) or paste CSV data:\n\nURL1,Name1\nURL2,Name2\nURL3,Name3',
              hintStyle: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppTheme.secondaryText),
              filled: true,
              fillColor: AppTheme.primaryBackground,
              border: OutlineInputBorder(
                
                borderSide: BorderSide(
                  color: AppTheme.border,
                  width: 1)),
              enabledBorder: OutlineInputBorder(
                
                borderSide: BorderSide(
                  color: AppTheme.border,
                  width: 1)),
              focusedBorder: OutlineInputBorder(
                
                borderSide: BorderSide(
                  color: AppTheme.accent,
                  width: 2))),
            onChanged: (value) {
              _processInput(value);
            }),
          SizedBox(height: 16.h),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _uploadCSVFile(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryText,
                    side: BorderSide(color: AppTheme.border),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file_rounded,
                        size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        'Upload CSV',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500)),
                    ]))),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: urlList.isNotEmpty && !isProcessing
                      ? () => _generateBatch()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryAction,
                    foregroundColor: AppTheme.primaryBackground,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder()),
                  child: isProcessing
                      ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryBackground)))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.generating_tokens_rounded,
                              size: 16.sp),
                            SizedBox(width: 4.w),
                            Text(
                              'Generate',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500)),
                          ]))),
            ]),
          
          // URL List Preview
          if (urlList.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                
                border: Border.all(
                  color: AppTheme.accent.withValues(alpha: 0.3),
                  width: 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview (${urlList.length} URLs)',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accent)),
                  SizedBox(height: 8.h),
                  ...urlList.take(3).map((url) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Text(
                      url,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppTheme.accent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis))).toList(),
                  if (urlList.length > 3)
                    Text(
                      '... and ${urlList.length - 3} more',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: AppTheme.accent)),
                ])),
          ],
          
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.1),
              
              border: Border.all(
                color: AppTheme.success.withValues(alpha: 0.3),
                width: 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batch Generation Features:',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.success)),
                SizedBox(height: 4.h),
                Text(
                  '• Automatic naming conventions\n• ZIP file export\n• Progress tracking\n• Error handling',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: AppTheme.success)),
              ])),
        ]));
  }

  void _processInput(String input) {
    if (input.trim().isEmpty) {
      setState(() {
        urlList.clear();
      });
      return;
    }

    List<String> lines = input.trim().split('\n');
    List<String> urls = [];
    
    for (String line in lines) {
      if (line.trim().isNotEmpty) {
        // Handle CSV format (URL,Name) or just URL
        String url = line.contains(',') ? line.split(',')[0].trim() : line.trim();
        if (url.isNotEmpty) {
          urls.add(url);
        }
      }
    }
    
    setState(() {
      urlList = urls;
    });
  }

  void _uploadCSVFile() {
    // Simulate file upload
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'CSV file upload feature coming soon',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppTheme.primaryText)),
        backgroundColor: AppTheme.accent.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder()));
  }

  void _generateBatch() async {
    setState(() {
      isProcessing = true;
    });
    
    try {
      // Simulate batch generation
      await Future.delayed(const Duration(seconds: 2));
      
      widget.onBatchGenerate(urlList);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Batch generation completed successfully',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.primaryText)),
            backgroundColor: AppTheme.success.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Batch generation failed. Please try again.',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppTheme.primaryText)),
            backgroundColor: AppTheme.error.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder()));
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }
}